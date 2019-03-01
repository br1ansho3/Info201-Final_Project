# Info201-Final_Project (BE)
> Henry Joseph Bates, Chunmo Chen, Brian Hsu, Ruiqi Yan

**Project Description**
1. What is the dataset you'll be working with?  Please include background on who collected the data, where you accessed it, and any additional information we should know about how this data came to be.

 - The data is collected by Spoonacular. We accessed that when searching for recipe api that have data for ingredients used in recipe. This data comes to build semantic relationships between food items like ingredients, recipes and store-bought products.

2. Who is your target audience?  Depending on the domain of your data, there may be a variety of audiences interested in using the dataset.  You should hone in on one of these audiences.

 - The target audience of the project is students who has limit budget and time but care about their diets.

3. What does your audience want to learn from your data?  Please list out at least 3 specific questions that your project will answer for your audience.

 - What the recipes are appropriate to provide certain amount of nutrition combination? What the proportion of each kind of nutrition for each recipe being selected?
 - How much calories absorbed in terms of the food eaten? How far the result calories from the daily calories limited set by user themselves.
 - Other

**Technical Description**

1. How will you be reading in your data (i.e., are you using an API, or is it a static .csv/.json file)?

 - We are using APIs. We are deciding to use a Recipe API and also a Nutrition Fact API.

2. What types of data-wrangling (reshaping, reformatting, etc.) will you need to do to your data?

    We are going to do:  
  - Reformatting: Transform list of ingredients and list of nutrition facts into integrated table; Generate a table of nutrition fact based on the recipe; Transform the ingredients ID provided by the data into real ingredients name;
  - Reshaping: Match ingredients with the nutrition table; Enable backward search by nutrition needed.
  - Data visualization: transform ingredient list and nutrition table to a more interactive diagram.

3. What (major/new) libraries will be using in this project?
  - Shiny
  - ggplot2
  - Plotly
  - ggiraph(http://davidgohel.github.io/ggiraph/) --maybe
  - DT(https://rstudio.github.io/DT/) --maybe
  - Highcharter(http://jkunst.com/highcharter/hchart.html) --maybe
  - Jsonlite
  - Httr

4. What major challenges do you anticipate?

  - How to design the input box so that the user can import their daily meal instead of one dish.
