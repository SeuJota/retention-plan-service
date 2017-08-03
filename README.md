## Resolução do teste

O teste foi desenvolvido utilizando `ruby 2.3.2` e `rspec 3.6`.

### Para rodar os testes projeto, siga os passos a seguir:

```
git clone https://github.com/SeuJota/retention-plan-service.git
```
Entre no diretório clonado:
```
cd retention-plan-service
```
Instale as dependências do projeto:
```
bundle install
```
E rode:
```
rspec
```

## Explicação da solução:

No momento que um objeto `RetentionPlan` é instanciado, já inicializo os planos descritos no enunciado.

```ruby
@plans ||= {}
@plans[:standard] = { days: 42 }
@plans[:gold] = { days: 42, months: 12 }
@plans[:platinum] = { days: 42, months: 12, years: 7 }
```

Caso seja necessário, adicionar um plano customizado, basta chamar o método `add_plan(plan, rules)`, passando o nome do plano e suas regras ex:

```ruby
retention_plan = RetentionPlan.new
rules = {days: 1, months: 1, years: 1}
retention_plan.add_plan(:emerald, rules)
```

E para fazer a checagem de validade de estadia de um Snapshot, basta chamar o método `status(plan, created_at)` passando o plano, e a data em que foi criado o Snapshot Ex.

```ruby
retention_plan = RetentionPlan.new
created_at_standart = Data.today - 43 #Plano standard permanece por 42 dias
retention_plan.status(:standard, created_at_standart)
# => 'deleted'
```
