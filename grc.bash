#!/usr/local/bin/bash

 Red='\033[1;91m'        # Red
  Yellow='\033[1;93m'     # Yellow
  Purple='\033[1;95m'     # Purple
  Cyan='\033[1;96m'       # Cyan
  Green='\033[1;32m'       # Green
  NaN='\033[0m'


function g {
  while test $# -gt 0; do
  case "$1" in
    -c)
     if [[ -z $2 ]];
       then grc
     else 
       grc $2
    fi
    break
    ;;
    -p)
    if [[ -z $2 ]];
      then
        echo -e $Red enter name for page: $NaN
        read name
        echo -e $Purple Generating page... $NaN 
        touch $PWD/src/pages/$name.js
        sed -e "s/PAGE_NAME/$name/g" $PWD/templates/page.js > src/pages/$name.js
        echo -e $Green 'Page created!' $NaN
      else
        echo -e $Purple Generating page... $NaN 
        touch $PWD/src/pages/$2.js
        sed -e "s/PAGE_NAME/$2/g" $PWD/templates/page.js > src/pages/$2.js
        echo -e $Green 'Page created!' $NaN
      fi
      break
    ;;
    -dc)
     if [[ -z $2 ]];
      then
        echo -e $Red Component to delete: $NaN
        read name
        dir="$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"

        echo -e $Purple Deleting $dir... $NaN 
        rm -rf $PWD/src/components/$dir
        echo -e $Purple Deleting from index... $NaN 

        sed -i "" "/$dir/d" $PWD/src/components/index.js

        echo -e $Green $dir deleted! $NaN
      else
        dir="$(tr '[:lower:]' '[:upper:]' <<< ${2:0:1})${2:1}"
        echo -e $Purple Deleting $dir... $NaN 
        rm -rf $PWD/src/components/$dir
        sed -i "" "/$dir/d" $PWD/src/components/index.js
        echo -e $Green $dir deleted! $NaN
      fi
      break
    ;;
    -dp)
     if [[ -z $2 ]];
      then
        echo -e $Red page to delete: $NaN
        read name
        echo -e $Purple Deleting $name... $NaN 
        rm $PWD/src/pages/$name.js
        echo -e $Purple Deleting page... $NaN 
        echo -e $Green $name deleted! $NaN
      else
        echo -e $Purple Deleting $2... $NaN 
        rm $PWD/src/pages/$2.js
        echo -e $Green $2 deleted! $NaN
      fi
      break
    ;;

    *)
      break
      ;;
  esac
done

}
function grc () {

echo $Purple 'React Component Generator' $NaN
echo $Purple '--------------------------' $NaN

cd $PWD

function createStylesheet {
    echo -e $Purple Generating style sheet... $NaN
    touch $PWD/src/components/$1/styles.js
    sed -e "s/COMPONENT_NAME/$1/g" $PWD/templates/style.js > src/components/$1/styles.js
    echo -e $Green 'Style file created!' $NaN
}

function createIndex {
  echo -e $Purple Generating index file... $NaN 
  touch $PWD/src/components/$1/index.jsx
  sed -e "s/COMPONENT_NAME/$1/g" $PWD/templates/react.js > src/components/$1/index.jsx
  echo -e $Green 'Index file created!' $NaN
}

function createComponent {
   dir="$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"

  if [[ -z $1 ]]
    then 
      echo -e $Red 'No name entered' $NaN
      exit
    else
      echo -e $Yellow Generating component directory for: $Cyan$dir$NaN... 
      mkdir -p $PWD/src/components/$dir
      # generate index file
      createIndex $dir
      # generate style sheet
      createStylesheet $dir  

      echo
      echo "export { default as $dir } from './$dir'" >> $PWD/src/components/index.js
  fi
}


if [[ -z $1 ]] 
  then 
    echo $Cyan 'Enter component name:' $NaN
    read name
    createComponent $name
  else
    createComponent $1
fi
}