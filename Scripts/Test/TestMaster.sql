

--CRUD PRODUCT
CALL CreateProduct('cacique', '1 month', 1, 'plastic bottle 500ml', 'dolar', 3, 1, false, true);

SELECT * FROM ReadProduct('cacique');

CALL UpdateProduct('cacique', 'imperial', '1 month', 1, 'glass bottle 700ml', 'dolar', 4, 1, false);

CALL DeleteProduct('imperial');



--CRUD TYPEPRODUCT
CALL CreateProductType('new');

SELECT * FROM ReadProductType('new');

CALL UpdateProductType('new', 'old');

CALL DeleteProductType('old');



--CRUD WORKER
CALL CreateWorker(2000, 3000, 'joaquin', '3000999', 'joaqui@gmail.com', '22002200', 3);

SELECT * FROM ReadWorker('joaquin');

CALL UpdateWorker('joaquin', 100, 300, 'gerardo', '2000000', 'gera@gmail.com', '8777777', 3);

CALL DeleteWorker('gerardo');





--QUERIES
SELECT * FROM GetProductsByName('whisky', true);

SELECT * FROM GetProductsByType('Irish', true);

SELECT * FROM GetProductsByCost(3000, true);

SELECT * FROM GetProductsByBestSeller(true);



--Review
CALL SetReview('kiko', 'really good product, I am glad to bought it', 1, 5, 'Scotland');



--Evaluation
CALL CreateEvaluation('Juan', 'kiko', 'bad worker, so rough', 1, 'Usa');

CALL CreateAnswerEvaluation(1, 'Ana', 'Thanks for the comment, we are going to figure it out', 'Usa');




--Buy
CALL BuyWhisky('Scotland', 1, 1, 1, 10);


--DELIVERY
CALL SetDelivery(1, 1, 'Scotland', 2);


--BILL
SELECT * FROM GetBilling(1, 'Scotland', 10, NOW()::DATE);





 

