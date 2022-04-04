{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "fae32285",
   "metadata": {
    "_cell_guid": "b1076dfc-b9ad-4769-8c92-a6c4dae69d19",
    "_uuid": "8f2839f25d086af736a60e9eeb907d3b93b6e0e5",
    "execution": {
     "iopub.execute_input": "2022-04-04T10:21:32.974382Z",
     "iopub.status.busy": "2022-04-04T10:21:32.971218Z",
     "iopub.status.idle": "2022-04-04T10:21:34.405741Z",
     "shell.execute_reply": "2022-04-04T10:21:34.404536Z"
    },
    "papermill": {
     "duration": 1.452697,
     "end_time": "2022-04-04T10:21:34.405910",
     "exception": false,
     "start_time": "2022-04-04T10:21:32.953213",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "df <- read.csv(\"../input/weather-dataset-rattle-package/weatherAUS.csv\", header = TRUE, sep = \",\", fill = TRUE)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "9f6c0c4f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-04-04T10:21:34.462330Z",
     "iopub.status.busy": "2022-04-04T10:21:34.434476Z",
     "iopub.status.idle": "2022-04-04T10:21:34.635383Z",
     "shell.execute_reply": "2022-04-04T10:21:34.633722Z"
    },
    "papermill": {
     "duration": 0.217246,
     "end_time": "2022-04-04T10:21:34.635537",
     "exception": false,
     "start_time": "2022-04-04T10:21:34.418291",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Loading required package: R.oo\n",
      "\n",
      "Loading required package: R.methodsS3\n",
      "\n",
      "R.methodsS3 v1.8.1 (2020-08-26 16:20:06 UTC) successfully loaded. See ?R.methodsS3 for help.\n",
      "\n",
      "R.oo v1.24.0 (2020-08-26 16:11:58 UTC) successfully loaded. See ?R.oo for help.\n",
      "\n",
      "\n",
      "Attaching package: ‘R.oo’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:R.methodsS3’:\n",
      "\n",
      "    throw\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:methods’:\n",
      "\n",
      "    getClasses, getMethods\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    attach, detach, load, save\n",
      "\n",
      "\n",
      "R.utils v2.10.1 (2020-08-26 22:50:31 UTC) successfully loaded. See ?R.utils for help.\n",
      "\n",
      "\n",
      "Attaching package: ‘R.utils’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:utils’:\n",
      "\n",
      "    timestamp\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    cat, commandArgs, getOption, inherits, isOpen, nullfile, parse,\n",
      "    warnings\n",
      "\n",
      "\n",
      "\n",
      "Attaching package: ‘dplyr’\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:stats’:\n",
      "\n",
      "    filter, lag\n",
      "\n",
      "\n",
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    intersect, setdiff, setequal, union\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(\"R.utils\")\n",
    "library(\"dplyr\")"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "7898affc",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-04-04T10:21:34.690450Z",
     "iopub.status.busy": "2022-04-04T10:21:34.688505Z",
     "iopub.status.idle": "2022-04-04T10:21:35.102594Z",
     "shell.execute_reply": "2022-04-04T10:21:35.101279Z"
    },
    "papermill": {
     "duration": 0.441675,
     "end_time": "2022-04-04T10:21:35.102787",
     "exception": false,
     "start_time": "2022-04-04T10:21:34.661112",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 10 × 23</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Date</th><th scope=col>Location</th><th scope=col>MinTemp</th><th scope=col>MaxTemp</th><th scope=col>Rainfall</th><th scope=col>Evaporation</th><th scope=col>Sunshine</th><th scope=col>WindGustDir</th><th scope=col>WindGustSpeed</th><th scope=col>WindDir9am</th><th scope=col>⋯</th><th scope=col>Humidity9am</th><th scope=col>Humidity3pm</th><th scope=col>Pressure9am</th><th scope=col>Pressure3pm</th><th scope=col>Cloud9am</th><th scope=col>Cloud3pm</th><th scope=col>Temp9am</th><th scope=col>Temp3pm</th><th scope=col>RainToday</th><th scope=col>RainTomorrow</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>⋯</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>120553</th><td>2017-04-01</td><td>PerthAirport</td><td>14.7</td><td>30.1</td><td> 0.0</td><td>8.2</td><td>10.8</td><td>E  </td><td>56</td><td>E  </td><td>⋯</td><td> 49</td><td>19</td><td>1024.0</td><td>1020.3</td><td> 0</td><td> 0</td><td>19.6</td><td>30.1</td><td>No </td><td>No </td></tr>\n",
       "\t<tr><th scope=row>93703</th><td>2010-01-27</td><td>Townsville  </td><td>24.4</td><td>28.6</td><td>40.8</td><td>1.0</td><td> 0.3</td><td>E  </td><td>46</td><td>ESE</td><td>⋯</td><td> 85</td><td>98</td><td>1008.2</td><td>1005.8</td><td> 7</td><td> 8</td><td>28.0</td><td>25.1</td><td>Yes</td><td>Yes</td></tr>\n",
       "\t<tr><th scope=row>98469</th><td>2014-08-16</td><td>Adelaide    </td><td>10.3</td><td>14.0</td><td> 0.0</td><td> NA</td><td>  NA</td><td>SE </td><td>46</td><td>SW </td><td>⋯</td><td> 75</td><td>60</td><td>1021.6</td><td>1019.4</td><td>NA</td><td>NA</td><td>10.3</td><td>13.0</td><td>No </td><td>Yes</td></tr>\n",
       "\t<tr><th scope=row>68844</th><td>2013-03-29</td><td>Melbourne   </td><td>10.9</td><td>18.5</td><td>  NA</td><td>5.4</td><td> 3.1</td><td>SSW</td><td>37</td><td>W  </td><td>⋯</td><td> 67</td><td>52</td><td>1021.8</td><td>1019.9</td><td>NA</td><td>NA</td><td>12.6</td><td>17.4</td><td>NA </td><td>NA </td></tr>\n",
       "\t<tr><th scope=row>79551</th><td>2013-07-09</td><td>Watsonia    </td><td> 0.3</td><td>13.6</td><td> 0.0</td><td>2.6</td><td> 8.2</td><td>NE </td><td>13</td><td>NNE</td><td>⋯</td><td>100</td><td>54</td><td>1037.4</td><td>1033.1</td><td> 1</td><td> 4</td><td> 1.7</td><td>13.3</td><td>No </td><td>No </td></tr>\n",
       "\t<tr><th scope=row>37732</th><td>2012-05-17</td><td>WaggaWagga  </td><td> 2.1</td><td>17.6</td><td> 0.0</td><td>1.0</td><td> 9.7</td><td>E  </td><td>17</td><td>E  </td><td>⋯</td><td> 78</td><td>38</td><td>1025.9</td><td>1022.2</td><td> 1</td><td> 5</td><td> 7.1</td><td>17.5</td><td>No </td><td>No </td></tr>\n",
       "\t<tr><th scope=row>71443</th><td>2011-12-16</td><td>Mildura     </td><td>15.2</td><td>35.2</td><td> 0.0</td><td>8.0</td><td>10.6</td><td>N  </td><td>28</td><td>SE </td><td>⋯</td><td> 52</td><td>10</td><td>1014.4</td><td>1011.4</td><td> 1</td><td> 7</td><td>22.1</td><td>34.2</td><td>No </td><td>No </td></tr>\n",
       "\t<tr><th scope=row>102127</th><td>2016-04-25</td><td>MountGambier</td><td> 7.0</td><td>26.6</td><td> 0.2</td><td>4.6</td><td> 9.6</td><td>NNW</td><td>43</td><td>N  </td><td>⋯</td><td> 53</td><td>19</td><td>1027.0</td><td>1023.9</td><td> 0</td><td> 0</td><td>16.7</td><td>25.8</td><td>No </td><td>No </td></tr>\n",
       "\t<tr><th scope=row>117870</th><td>2009-08-29</td><td>PerthAirport</td><td> 0.9</td><td>16.7</td><td> 3.2</td><td>3.4</td><td>10.5</td><td>SSW</td><td>37</td><td>NE </td><td>⋯</td><td> 72</td><td>41</td><td>1026.5</td><td>1025.6</td><td> 1</td><td> 4</td><td> 9.3</td><td>14.9</td><td>Yes</td><td>No </td></tr>\n",
       "\t<tr><th scope=row>71245</th><td>2011-06-01</td><td>Mildura     </td><td> 2.4</td><td>20.2</td><td> 0.0</td><td>1.8</td><td> 9.1</td><td>SE </td><td>17</td><td>SSE</td><td>⋯</td><td> 86</td><td>49</td><td>1026.5</td><td>1023.9</td><td> 3</td><td> 1</td><td> 7.7</td><td>20.1</td><td>No </td><td>No </td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 10 × 23\n",
       "\\begin{tabular}{r|lllllllllllllllllllll}\n",
       "  & Date & Location & MinTemp & MaxTemp & Rainfall & Evaporation & Sunshine & WindGustDir & WindGustSpeed & WindDir9am & ⋯ & Humidity9am & Humidity3pm & Pressure9am & Pressure3pm & Cloud9am & Cloud3pm & Temp9am & Temp3pm & RainToday & RainTomorrow\\\\\n",
       "  & <chr> & <chr> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <chr> & <int> & <chr> & ⋯ & <int> & <int> & <dbl> & <dbl> & <int> & <int> & <dbl> & <dbl> & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t120553 & 2017-04-01 & PerthAirport & 14.7 & 30.1 &  0.0 & 8.2 & 10.8 & E   & 56 & E   & ⋯ &  49 & 19 & 1024.0 & 1020.3 &  0 &  0 & 19.6 & 30.1 & No  & No \\\\\n",
       "\t93703 & 2010-01-27 & Townsville   & 24.4 & 28.6 & 40.8 & 1.0 &  0.3 & E   & 46 & ESE & ⋯ &  85 & 98 & 1008.2 & 1005.8 &  7 &  8 & 28.0 & 25.1 & Yes & Yes\\\\\n",
       "\t98469 & 2014-08-16 & Adelaide     & 10.3 & 14.0 &  0.0 &  NA &   NA & SE  & 46 & SW  & ⋯ &  75 & 60 & 1021.6 & 1019.4 & NA & NA & 10.3 & 13.0 & No  & Yes\\\\\n",
       "\t68844 & 2013-03-29 & Melbourne    & 10.9 & 18.5 &   NA & 5.4 &  3.1 & SSW & 37 & W   & ⋯ &  67 & 52 & 1021.8 & 1019.9 & NA & NA & 12.6 & 17.4 & NA  & NA \\\\\n",
       "\t79551 & 2013-07-09 & Watsonia     &  0.3 & 13.6 &  0.0 & 2.6 &  8.2 & NE  & 13 & NNE & ⋯ & 100 & 54 & 1037.4 & 1033.1 &  1 &  4 &  1.7 & 13.3 & No  & No \\\\\n",
       "\t37732 & 2012-05-17 & WaggaWagga   &  2.1 & 17.6 &  0.0 & 1.0 &  9.7 & E   & 17 & E   & ⋯ &  78 & 38 & 1025.9 & 1022.2 &  1 &  5 &  7.1 & 17.5 & No  & No \\\\\n",
       "\t71443 & 2011-12-16 & Mildura      & 15.2 & 35.2 &  0.0 & 8.0 & 10.6 & N   & 28 & SE  & ⋯ &  52 & 10 & 1014.4 & 1011.4 &  1 &  7 & 22.1 & 34.2 & No  & No \\\\\n",
       "\t102127 & 2016-04-25 & MountGambier &  7.0 & 26.6 &  0.2 & 4.6 &  9.6 & NNW & 43 & N   & ⋯ &  53 & 19 & 1027.0 & 1023.9 &  0 &  0 & 16.7 & 25.8 & No  & No \\\\\n",
       "\t117870 & 2009-08-29 & PerthAirport &  0.9 & 16.7 &  3.2 & 3.4 & 10.5 & SSW & 37 & NE  & ⋯ &  72 & 41 & 1026.5 & 1025.6 &  1 &  4 &  9.3 & 14.9 & Yes & No \\\\\n",
       "\t71245 & 2011-06-01 & Mildura      &  2.4 & 20.2 &  0.0 & 1.8 &  9.1 & SE  & 17 & SSE & ⋯ &  86 & 49 & 1026.5 & 1023.9 &  3 &  1 &  7.7 & 20.1 & No  & No \\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 10 × 23\n",
       "\n",
       "| <!--/--> | Date &lt;chr&gt; | Location &lt;chr&gt; | MinTemp &lt;dbl&gt; | MaxTemp &lt;dbl&gt; | Rainfall &lt;dbl&gt; | Evaporation &lt;dbl&gt; | Sunshine &lt;dbl&gt; | WindGustDir &lt;chr&gt; | WindGustSpeed &lt;int&gt; | WindDir9am &lt;chr&gt; | ⋯ ⋯ | Humidity9am &lt;int&gt; | Humidity3pm &lt;int&gt; | Pressure9am &lt;dbl&gt; | Pressure3pm &lt;dbl&gt; | Cloud9am &lt;int&gt; | Cloud3pm &lt;int&gt; | Temp9am &lt;dbl&gt; | Temp3pm &lt;dbl&gt; | RainToday &lt;chr&gt; | RainTomorrow &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 120553 | 2017-04-01 | PerthAirport | 14.7 | 30.1 |  0.0 | 8.2 | 10.8 | E   | 56 | E   | ⋯ |  49 | 19 | 1024.0 | 1020.3 |  0 |  0 | 19.6 | 30.1 | No  | No  |\n",
       "| 93703 | 2010-01-27 | Townsville   | 24.4 | 28.6 | 40.8 | 1.0 |  0.3 | E   | 46 | ESE | ⋯ |  85 | 98 | 1008.2 | 1005.8 |  7 |  8 | 28.0 | 25.1 | Yes | Yes |\n",
       "| 98469 | 2014-08-16 | Adelaide     | 10.3 | 14.0 |  0.0 |  NA |   NA | SE  | 46 | SW  | ⋯ |  75 | 60 | 1021.6 | 1019.4 | NA | NA | 10.3 | 13.0 | No  | Yes |\n",
       "| 68844 | 2013-03-29 | Melbourne    | 10.9 | 18.5 |   NA | 5.4 |  3.1 | SSW | 37 | W   | ⋯ |  67 | 52 | 1021.8 | 1019.9 | NA | NA | 12.6 | 17.4 | NA  | NA  |\n",
       "| 79551 | 2013-07-09 | Watsonia     |  0.3 | 13.6 |  0.0 | 2.6 |  8.2 | NE  | 13 | NNE | ⋯ | 100 | 54 | 1037.4 | 1033.1 |  1 |  4 |  1.7 | 13.3 | No  | No  |\n",
       "| 37732 | 2012-05-17 | WaggaWagga   |  2.1 | 17.6 |  0.0 | 1.0 |  9.7 | E   | 17 | E   | ⋯ |  78 | 38 | 1025.9 | 1022.2 |  1 |  5 |  7.1 | 17.5 | No  | No  |\n",
       "| 71443 | 2011-12-16 | Mildura      | 15.2 | 35.2 |  0.0 | 8.0 | 10.6 | N   | 28 | SE  | ⋯ |  52 | 10 | 1014.4 | 1011.4 |  1 |  7 | 22.1 | 34.2 | No  | No  |\n",
       "| 102127 | 2016-04-25 | MountGambier |  7.0 | 26.6 |  0.2 | 4.6 |  9.6 | NNW | 43 | N   | ⋯ |  53 | 19 | 1027.0 | 1023.9 |  0 |  0 | 16.7 | 25.8 | No  | No  |\n",
       "| 117870 | 2009-08-29 | PerthAirport |  0.9 | 16.7 |  3.2 | 3.4 | 10.5 | SSW | 37 | NE  | ⋯ |  72 | 41 | 1026.5 | 1025.6 |  1 |  4 |  9.3 | 14.9 | Yes | No  |\n",
       "| 71245 | 2011-06-01 | Mildura      |  2.4 | 20.2 |  0.0 | 1.8 |  9.1 | SE  | 17 | SSE | ⋯ |  86 | 49 | 1026.5 | 1023.9 |  3 |  1 |  7.7 | 20.1 | No  | No  |\n",
       "\n"
      ],
      "text/plain": [
       "       Date       Location     MinTemp MaxTemp Rainfall Evaporation Sunshine\n",
       "120553 2017-04-01 PerthAirport 14.7    30.1     0.0     8.2         10.8    \n",
       "93703  2010-01-27 Townsville   24.4    28.6    40.8     1.0          0.3    \n",
       "98469  2014-08-16 Adelaide     10.3    14.0     0.0      NA           NA    \n",
       "68844  2013-03-29 Melbourne    10.9    18.5      NA     5.4          3.1    \n",
       "79551  2013-07-09 Watsonia      0.3    13.6     0.0     2.6          8.2    \n",
       "37732  2012-05-17 WaggaWagga    2.1    17.6     0.0     1.0          9.7    \n",
       "71443  2011-12-16 Mildura      15.2    35.2     0.0     8.0         10.6    \n",
       "102127 2016-04-25 MountGambier  7.0    26.6     0.2     4.6          9.6    \n",
       "117870 2009-08-29 PerthAirport  0.9    16.7     3.2     3.4         10.5    \n",
       "71245  2011-06-01 Mildura       2.4    20.2     0.0     1.8          9.1    \n",
       "       WindGustDir WindGustSpeed WindDir9am ⋯ Humidity9am Humidity3pm\n",
       "120553 E           56            E          ⋯  49         19         \n",
       "93703  E           46            ESE        ⋯  85         98         \n",
       "98469  SE          46            SW         ⋯  75         60         \n",
       "68844  SSW         37            W          ⋯  67         52         \n",
       "79551  NE          13            NNE        ⋯ 100         54         \n",
       "37732  E           17            E          ⋯  78         38         \n",
       "71443  N           28            SE         ⋯  52         10         \n",
       "102127 NNW         43            N          ⋯  53         19         \n",
       "117870 SSW         37            NE         ⋯  72         41         \n",
       "71245  SE          17            SSE        ⋯  86         49         \n",
       "       Pressure9am Pressure3pm Cloud9am Cloud3pm Temp9am Temp3pm RainToday\n",
       "120553 1024.0      1020.3       0        0       19.6    30.1    No       \n",
       "93703  1008.2      1005.8       7        8       28.0    25.1    Yes      \n",
       "98469  1021.6      1019.4      NA       NA       10.3    13.0    No       \n",
       "68844  1021.8      1019.9      NA       NA       12.6    17.4    NA       \n",
       "79551  1037.4      1033.1       1        4        1.7    13.3    No       \n",
       "37732  1025.9      1022.2       1        5        7.1    17.5    No       \n",
       "71443  1014.4      1011.4       1        7       22.1    34.2    No       \n",
       "102127 1027.0      1023.9       0        0       16.7    25.8    No       \n",
       "117870 1026.5      1025.6       1        4        9.3    14.9    Yes      \n",
       "71245  1026.5      1023.9       3        1        7.7    20.1    No       \n",
       "       RainTomorrow\n",
       "120553 No          \n",
       "93703  Yes         \n",
       "98469  Yes         \n",
       "68844  NA          \n",
       "79551  No          \n",
       "37732  No          \n",
       "71443  No          \n",
       "102127 No          \n",
       "117870 No          \n",
       "71245  No          "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "n <- length(df[,1]) \n",
    "index <- sample(1:n,n,replace=FALSE) \n",
    "df <- df[index,]\n",
    "\n",
    "df[1:10,]\n",
    "\n",
    "df[, \"Date\"] <- as.Date(df[, \"Date\"])\n",
    "df[, \"Location\"] <- as.factor(df[, \"Location\"])\n",
    "df[, \"WindGustDir\"] <- as.factor(df[, \"WindGustDir\"])\n",
    "df[, \"WindDir9am\"] <- as.factor(df[, \"WindDir9am\"])\n",
    "df[, \"WindDir3pm\"] <- as.factor(df[, \"WindDir3pm\"])\n",
    "df[, \"RainToday\"] <- as.factor(df[, \"RainToday\"])\n",
    "df[, \"RainTomorrow\"] <- as.factor(df [, \"RainTomorrow\"])\n",
    "df[\"Cloud9am\"][df[\"Cloud9am\"] == 9] <- 8\n",
    "df[\"Cloud3pm\"][df[\"Cloud3pm\"] == 9] <- 8\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "79ce2907",
   "metadata": {
    "papermill": {
     "duration": 0.025839,
     "end_time": "2022-04-04T10:21:35.154066",
     "exception": false,
     "start_time": "2022-04-04T10:21:35.128227",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Deskriptive Analyse"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "c9426a00",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2022-04-04T10:21:35.209474Z",
     "iopub.status.busy": "2022-04-04T10:21:35.207950Z",
     "iopub.status.idle": "2022-04-04T10:21:35.393471Z",
     "shell.execute_reply": "2022-04-04T10:21:35.392072Z"
    },
    "papermill": {
     "duration": 0.215456,
     "end_time": "2022-04-04T10:21:35.393653",
     "exception": false,
     "start_time": "2022-04-04T10:21:35.178197",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Mean(MinTemp): 12.194034\n",
      "Median(MinTemp): 12.000000\n",
      "Standard deviation(MinTemp): 6.398495\n",
      "\n",
      "Mean(MaxTemp): 23.221348\n",
      "Median(MaxTemp): 22.600000\n",
      "Standard deviation(MaxTemp): 7.119049\n",
      "\n",
      "Mean(Rainfall): 2.360918\n",
      "Median(Rainfall): 0.000000\n",
      "Standard deviation(Rainfall): 8.478060\n",
      "\n",
      "Mean(Evaporation): 5.468232\n",
      "Median(Evaporation): 4.800000\n",
      "Standard deviation(Evaporation): 4.193704\n",
      "\n",
      "Mean(Sunshine): 7.611178\n",
      "Median(Sunshine): 8.400000\n",
      "Standard deviation(Sunshine): 3.785483\n",
      "\n",
      "Mean(WindGustSpeed): 40.035230\n",
      "Median(WindGustSpeed): 39.000000\n",
      "Standard deviation(WindGustSpeed): 13.607062\n",
      "\n",
      "Mean(WindSpeed9am): 14.043426\n",
      "Median(WindSpeed9am): 13.000000\n",
      "Standard deviation(WindSpeed9am): 8.915375\n",
      "\n",
      "Mean(WindSpeed3pm): 18.662657\n",
      "Median(WindSpeed3pm): 19.000000\n",
      "Standard deviation(WindSpeed3pm): 8.809800\n",
      "\n",
      "Mean(Humidity9am): 68.880831\n",
      "Median(Humidity9am): 70.000000\n",
      "Standard deviation(Humidity9am): 19.029164\n",
      "\n",
      "Mean(Humidity3pm): 51.539116\n",
      "Median(Humidity3pm): 52.000000\n",
      "Standard deviation(Humidity3pm): 20.795902\n",
      "\n",
      "Mean(Pressure9am): 1017.649940\n",
      "Median(Pressure9am): 1017.600000\n",
      "Standard deviation(Pressure9am): 7.106530\n",
      "\n",
      "Mean(Pressure3pm): 1015.255889\n",
      "Median(Pressure3pm): 1015.200000\n",
      "Standard deviation(Pressure3pm): 7.037414\n",
      "\n",
      "Mean(Cloud9am): 4.447439\n",
      "Median(Cloud9am): 5.000000\n",
      "Standard deviation(Cloud9am): 2.887128\n",
      "\n",
      "Mean(Cloud3pm): 4.509918\n",
      "Median(Cloud3pm): 5.000000\n",
      "Standard deviation(Cloud3pm): 2.720340\n",
      "\n",
      "Mean(Temp9am): 16.990631\n",
      "Median(Temp9am): 16.700000\n",
      "Standard deviation(Temp9am): 6.488753\n",
      "\n",
      "Mean(Temp3pm): 21.683390\n",
      "Median(Temp3pm): 21.100000\n",
      "Standard deviation(Temp3pm): 6.936650\n",
      "\n"
     ]
    }
   ],
   "source": [
    "parameters <- names(select_if(df, is.numeric))\n",
    "\n",
    "for (x in parameters) {\n",
    "  printf(\"Mean(%s): %f\\n\", x, mean(df[, x], na.rm = TRUE))\n",
    "  printf(\"Median(%s): %f\\n\", x, median(df[, x], na.rm = TRUE))\n",
    "  printf(\"Standard deviation(%s): %f\\n\\n\", x, sd(df[, x], na.rm = TRUE))\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "62f62477",
   "metadata": {
    "papermill": {
     "duration": 0.024996,
     "end_time": "2022-04-04T10:21:35.445106",
     "exception": false,
     "start_time": "2022-04-04T10:21:35.420110",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 5.922861,
   "end_time": "2022-04-04T10:21:35.579340",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2022-04-04T10:21:29.656479",
   "version": "2.3.3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
