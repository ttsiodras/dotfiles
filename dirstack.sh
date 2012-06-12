# Shamelessly copied from https://gist.github.com/1154129

export DIRSTACK_MAX=30
DS=()

function eecho
{
    echo $@ 1>&2
}

function shiftStackUp
{
  typeset num=$1
  typeset -i c=$((num+1))

  while (( $c < ${#DS[*]} ))
  do
    DS[$((c-1))]="${DS[$c]}"
    ((c=c+1))
  done
  unset DS[$((${#DS[*]}-1))]
}

function shiftStackDown
{
  typeset num=$1
  typeset -i c=${#DS[*]}

  while (( $c > $num ))
  do
    DS[$c]="${DS[$((c-1))]}"
    ((c=c-1))
  done
}

function popStack
{
  if [[ ${#DS[*]} == 0 ]]; then
    eecho "Cannot pop stack.  No elements to pop."
    return 1
  fi
  typeset retv="${DS[0]}"
  shiftStackUp 0

  echo $retv
}

function pushStack
{
  typeset newvalue="$1"
  typeset -i c=0

  while (( $c < ${#DS[*]} ))
  do
    if [[ "${DS[$c]}" == "$newvalue" ]]; then
      shiftStackUp $c
    else
      ((c=c+1))
    fi
  done
  shiftStackDown 0
  DS[0]="$newvalue"
  if [[ ${#DS[*]} -gt $DIRSTACK_MAX ]]; then
    unset DS[$((${#DS[*]}-1))]
  fi
} 

function cd_
{
  typeset ret=0

  if [ $# == 0 ]; then
    pd "$HOME"
    ret=$?
  elif [[ $# == 1 && "$1" == "-" ]]; then
    pd
    ret=$?
  elif [ $# -gt 1 ]; then
    typeset from="$1"
    typeset to="$2"
    typeset c=0
    typeset path=
    typeset x=$(pwd)
    typeset numberOfFroms=$(echo $x | tr '/' '\n' | grep "^$from$" | wc -l)
    while [ $c -lt $numberOfFroms ]
    do
        path=
        typeset subc=$c
        typeset tokencount=0
        for subdir in $(echo $x | tr '/' '\n' | tail -n +2)
        do
            if [[ "$subdir" == "$from" ]]; then
                if [ $subc -eq $tokencount ]; then
                    path="$path/$to"
                    subc=$((subc+1))
                else
                    path="$path/$from"
                    tokencount=$((tokencount+1))
                fi
            else
                path="$path/$subdir"
            fi
        done
        if [ -d "$path" ]; then
            break
        fi
        c=$((c=c+1))
    done
    if [ "$path" == "$x" ]; then
        echo "Bad substitution"
        ret=1
    else
        pd "$path"
        ret=$?
    fi
  else
    pd "$1"
    ret=$?
  fi

  return $ret
} 

function pd
{
  typeset dirname="${1-}"
  typeset firstdir seconddir ret p oldDIRSTACK

  if [ "$dirname" == "" ]; then
    firstdir=$(pwd)
    if [ ${#DS[*]} == 0 ]; then
      eecho "Stack is empty.  Cannot swap."
      return 1
    fi
    seconddir=$(popStack)
    pushStack "$firstdir"
    "cd" "$seconddir"
    ret=$?
    return $ret
  else
    if [ -d "$dirname" ]; then
      if [ "$dirname" != '.' ]; then
        pushStack "$(pwd)"
      fi
      "cd" "$dirname"
      ret=$?
      return $ret
    else
      eecho "bash: $dirname: not found"
      return 1
    fi
  fi
} 

function ss
{
  typeset f x
  typeset -i c=0
  typeset re="${1-}"

  while (( $c < ${#DS[*]} ))
  do
    f=${DS[$c]}
    if [[ -n "$re" && "$(echo $f | grep $re)" == "" ]]; then
      ((c=c+1))
      continue
    fi
    if (( ${#f} > 120 )); then
      x="...$(echo $f | cut -c$((${#f}-120))-)"
    else
      x=$f
    fi
    echo "$((c+1))) $x"
    ((c=c+1))
  done
} 

function csd
{
  typeset num=${1-}
  typeset removedDirectory

#  if [ "${num##+([0-9])}" != "" ]; then
  if [ "$(echo $num | sed 's/^[0-9]*$//')" != "" ]; then
    c=0
    re=$num
    num=0
    while [ "$c" -lt "${#DS[*]}" ]
    do
      if echo "${DS[$c]}" | grep -q $re; then
        num=$(($c+1))
        break
      fi
      ((c=c+1))
    done
  fi
  if [ "$num" == 0 ]; then
    echo "usage: csd <number greater than 0 | regular expression>"
    return 1
  elif [ "$num" -gt "${#DS[*]}" ]; then
    echo "$num is beyond the stack size."
    return 1
  else
    num=$((num-1))
    typeset dir="${DS[$num]}"
    shiftStackUp $num
    cd_ "$dir"
    return $?
  fi
} 

alias cd=cd_
