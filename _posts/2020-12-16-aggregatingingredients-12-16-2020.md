---
layout: single
title: "Aggregating Ingredients"
tags: LS AnnaExtension
---

## How to aggregate ingredients from multiple recipe blogs?


```python

multi_blogs = ["https://www.gimmesomeoven.com/poblano-white-chicken-chili/",
"https://www.skinnytaste.com/lentil-soup-with-butternut-and-kale/",
"https://minimalistbaker.com/orange-cranberry-crisp-gluten-free-easy/",
"https://www.twopeasandtheirpod.com/magic-cookie-bars/",
"https://thedefineddish.com/miso-roasted-chicken/",
"https://www.ambitiouskitchen.com/coconut-curried-brown-rice/",
"https://whatsgabycooking.com/chicken-larb-bowls/",
"https://paleomg.com/paleo-blueberry-chai-muffins/"]

def get_print_link(url):
    r = requests.get(url)
    soup = BeautifulSoup(r.content, 'html.parser')
    searched_word = 'Print'
    results = soup.body.find_all(string=re.compile('.*{0}.*'.format(searched_word)), recursive=True)
    return results[0].parent['href']

print_links = []
for blog in multi_blogs:
    print_links.append(get_print_link(blog))

def get_ingredients_from_link(url):
    r = requests.get(url)
    soup = BeautifulSoup(r.content, 'html.parser')

    # recipe_name = soup.find_all('h3', 'wprm-recipe-name')[0].text.strip()
    recipe_name = 'test'
    ingredients = soup.find_all('li',"wprm-recipe-ingredient")
    all_ingredients = []

    for i in ingredients:
        try:
            amount = i.find_all("span","wprm-recipe-ingredient-amount")
            amount = amount[0].text

        except:
            amount = 'no amount'

        try:
            unit = i.find_all("span","wprm-recipe-ingredient-unit")
            unit = unit[0].text

        except:
            unit = 'no unit'

        try:
            name = i.find_all("span","wprm-recipe-ingredient-name")
            name = name[0].text

        except:
            name = 'no name'

        all_ingredients.append({'url': url, 
                                'recipe_name': recipe_name,
                                'amount': amount, 
                                'unit': unit, 
                                'name': name})

    return all_ingredients

not_working = []
all_ingredients = []
for link in print_links:
    ingredients = get_ingredients_from_link(link)
    if len(ingredients) == 0:
        not_working.append(link)
    else:
        all_ingredients.append(ingredients)
        
results_flattened = [item for sublist in all_ingredients for item in sublist]
shopping_list = {}
def add_ingredients_to_dictionary(formatted_ingredient):
#     print(formatted_ingredient)
    ingredient = formatted_ingredient['name']
    amount = formatted_ingredient['amount']
    unit = formatted_ingredient['unit']
    amount_unit = "{}({})".format(amount, unit)
    if ingredient in shopping_list:
        shopping_list[ingredient] = shopping_list[ingredient] + ' + ' + amount_unit
    else:
        shopping_list[ingredient] = amount_unit
        
my_list = [add_ingredients_to_dictionary(x) for x in results_flattened]
for site in not_working:
    print('So sorry, working on getting info from', site)
shopping_list
        

```