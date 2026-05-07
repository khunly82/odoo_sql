select
    supplier_id,
    avg(unit_price)
from products
group by supplier_id;

-- 4. Chiffre d'affaires par client
-- Calculez le montant total
-- (Quantité * Prix Unitaire)
-- dépensé par chaque client.
-- Affichez le company_name
-- du client et le total arrondi.

select
    round(SUM(unit_price*quantity) * 100) / 100 as total,
    c.company_name
from order_details od
join orders o on o.order_id = od.order_id
join customers c on c.customer_id = o.customer_id
group by c.company_name;

--6. Frais de port par transporteur
-- Calculez les frais de port moyens (freight)
-- pour chaque transporteur.
-- Affichez le nom du transporteur (shippers.company_name).

select
    avg(o.freight),
    s.company_name
from orders o
join shippers s on s.shipper_id = o.ship_via
group by s.company_name;

--8. Comparaison au maximum de la commande
-- Pour chaque ligne de la table order_details,
-- affichez l'ID de la commande,
-- le prix unitaire du produit actuel
-- et, dans une colonne supplémentaire,
-- le prix du produit le plus cher de cette même commande.
select
    order_id,
    -- unit_price,
    -- max(unit_price) over (partition by order_id)
    case
        when unit_price = min(unit_price) over (partition by order_id)
            then 0
        else unit_price
    end
from order_details;

-- 7. Classement des prix par catégorie
-- Affichez le nom du produit,
-- sa catégorie et son prix.
-- Ajoutez une colonne de classement (RANK ou DENSE_RANK)
-- qui classe les produits du plus cher au moins
-- cher à l'intérieur de chaque catégorie.

SELECT
    category_id,
    product_name,
    unit_price,
    rank() over (partition by category_id order by unit_price) as rank
FROM products;

-- 10. Délai entre deux commandes
-- Pour chaque client, affichez l'ID de la commande,
-- la date de la commande actuelle
-- et la date de la commande précédente passée
-- par ce même client (utilisez LAG)


select
    customer_id,
    order_id,
    order_date,
    lag(order_date) over (partition by customer_id order by order_date)
from orders;

-- 12. Top 3 des ventes par catégorie
-- Listez les 3 produits les plus vendus
-- (en termes de quantité totale) pour chaque catégorie.
select
    *
from (
    select
        p.product_name,
        category_name,
        sum(quantity),
        rank() over (partition by category_name order by sum(quantity) desc) as rank
    from categories c
    join products p on p.category_id = c.category_id
    join order_details od on od.product_id = p.product_id
    group by product_name, category_name
    order by category_name
) sub where rank < 4
