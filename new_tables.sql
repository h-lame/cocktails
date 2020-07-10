alter table Characteristic rename column type to category;

alter table Ingredient add column category TEXT NOT NULL DEFAULT 'booze';
alter table Ingredient add column description TEXT;
create index "ix_ingredient_category" on "Ingredient" (category);

create table if not exists "recipe_formulation_ingredients" (
  id integer not null,
  recipe_formulation_id integer not null,
  ingredient_id integer,
  ingredient_recipe_formulation_id integer,
  name text not null,
  PRIMARY KEY(id),
  FOREIGN KEY(recipe_formulation_id) REFERENCES "RecipeFormulation" (recipe_formulation_id),
  FOREIGN KEY(ingredient_id) REFERENCES "Ingredient" (ingredient_id),
  FOREIGN KEY(ingredient_recipe_formulation_id) REFERENCES "RecipeFormulation" (recipe_formulation_id)
);
create index "ix_recipe_formulation_ingredients_recipe_formulation_id" on "recipe_formulation_ingredients" (recipe_formulation_id);
create index "ix_recipe_formulation_ingredients_ingredient_id" on "recipe_formulation_ingredients" (ingredient_id);
create index "ix_recipe_formulation_ingredients_ingredient_recipe_formulation_id" on "recipe_formulation_ingredients" (ingredient_recipe_formulation_id);
