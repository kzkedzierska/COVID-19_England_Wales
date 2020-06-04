# README

This repository contains the data and code to generate figures as described on [kasia.codes/covid](https://kasia.codes/covid/).   
  
Date comes from [Office for National Statistics, *Deaths registered weekly in England and Wales, provisional* dataset](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales). Code is Open Source and under the [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/#) license. 

In order for this repo to be part of the Academic themed website and keep the nice outline of the website I needed to create a workaround the default compiling of `.Rmd` files by Hugo/blogdown.

1) I render the markdown to a separate file.

```bash
bash knit_manual.sh
```

2) I created a covid-19 directory in `static` with symbolic link to the manual notbeook. This allows my website to create a static page under kasia.codes/covid-19.

3) I updated the `index.md` under `content > post > covid-19` to redirect to the kasia.codes/covid-19 nicely formatted post. 

This is very far from ideal, but I would need to sacrifice floating table of content (which I can see myself doing) and folding the code (which I don't want) as those options are not supported by blogdown. Hopefully, they will become available or I will come up with more elegant solution.
