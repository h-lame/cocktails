alter table Characteristic rename column type to category;

alter table Ingredient add column category TEXT NOT NULL DEFAULT 'booze';
alter table Ingredient add column description TEXT;
create index "ix_ingredient_category" on "Ingredient" (category);

