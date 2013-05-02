class Item
	constructor: (@qty, @description, @unit_price, invoice) ->
		@amount = parseFloat(this.round(@qty * @unit_price))
		@id

	round: (amount) ->
		amount.toFixed(2)

	amount: ->
		@amount = parseFloat(this.round(@qty * @unit_price))

class Client
	constructor: (@name, @address, @city_state_zip, @phone) ->

class Company
	constructor: (@name, @address, @phone) ->


client = new Client("Coyote", "1 Road Runner rd.", "Address Line 2", "416-123-4567")
company = new Company("Company Name", "Company Address line 1\nCompany Address Line 2\nCity, State, Zip", "416-000-0000")


window.Invoice = angular.module('Invoice', [])


window.Invoice.controller 'InvoiceCtrl', ($scope) ->
	$scope.items = [new Item(1, "Acme Bird Seed", 13.25)]

	$scope.autoincrement = 0
	$scope.company = company
	$scope.client = client
	$scope.date = new Date().toLocaleDateString()
	$scope.number = (Math.random()*100).toFixed(0)
	$scope.freight = 0
	$scope.fields = []
	

	$scope.addField = ->
			$scope.fields.push ({name: '', value: '',  symbol: ''})


	$scope.addItem = ->
		item = new Item('','','')
		item.id = $scope.autoincrement
		$scope.items.push(item)
		++$scope.autoincrement


	$scope.removeItem = (id) ->
		i = 0
		for item in $scope.items
			if item.id == id
				$scope.items.splice(i,1)
				return
			else ++i

	$scope.updateSubtotal = ->
		sum = 0
		for item in $scope.items
			sum += (item.qty * item.unit_price)
		return sum

	$scope.subtotal = $scope.updateSubtotal()

	$scope.$watch 'items', ->
		$scope.subtotal = $scope.updateSubtotal()
		$scope.total = $scope.updateTotal()
	, true

	$scope.$watch 'fields', ->
		$scope.total = $scope.updateTotal()
	, true

	$scope.parseFields = ->
		for field in $scope.fields
			v = field.value
			if v[0] == "$" || v[0] == '€' || v[0] == '£'
				field.symbol = 'currency'
			else if v[v.length-1] == "%"
				field.symbol = '%'
			else
				field.symbol = ''

	$scope.updateTotal = ->
		t = $scope.subtotal
		$scope.parseFields()
		for field in $scope.fields
			if field.symbol == '%'
				t += (t * parseFloat(field.value)/100)
			else if field.symbol == 'currency'
				t += parseFloat(field.value.substring(1))
			else
				t += parseFloat(field.value)
		return t

	$scope.total = $scope.updateTotal()

	return
