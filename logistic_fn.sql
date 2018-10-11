if object_id('dbo.get_logistic_proba') is not null
   drop function dbo.get_logistic_proba;
go

/**
gets the probability estimate that the parameters passed 
in describe a property that is on the waterfront.
*/
create function dbo.get_logistic_proba(@sqft_living decimal, 
	@view_rating decimal,
	@condition_rating decimal)
returns decimal(38,18)
as 
begin
	declare @intercept decimal(38,18) = -6.54714592;
	declare @coef_sqft decimal(38,18) = -0.000183525095;
	declare @coef_view decimal(38,18) = 1.99677398;
	declare @coef_condition decimal(38,18) = -.399600510;
	
	declare @v decimal(38,18) = @intercept + 
		(@coef_sqft * @sqft_living) + 
		(@coef_view * @view_rating) + 
		(@coef_condition * @condition_rating);
	
	return(select 1.0 / (1.0 + exp(@v * -1)));
end

-- now just try it out...
select dbo.get_logistic_proba(1180.0, 0.0, 3.0) as low_proba, 
	dbo.get_logistic_proba(760.0, 4.0, 5.0) as high_proba

