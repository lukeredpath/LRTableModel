# LRTableModel, because implementing UITableViewDataSource sucks!

UITableViews are the ubiquitous building blocks of many iPhone and iPad applications. They are easy to add to your application - throw them in a XIB file, hook up your delegate and datasource outlets, and you're set...well, almost. You will be once you've gone through the tedious process of implementing those data source methods.

How many times have you written out something like this?

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
      static NSString *identifier = @"Cell";
  
      // yawn...
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
      if (cell == nil) {
        // don't forget that reuse identifier!
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
      }
  
      // at least extracting this keeps the method tidy...
      [self configureCell:cell atIndexPath:indexPath];
  
      return cell;
    }
    
OK, you may not have written it; it may have been generated for you (with some convenient placeholders for you to fill in) but the reality is that as your application develops, this method will grow and then you have to duplicate it for every table view controller in your application.

And then you have to decide where your table view should get it's data from. Should you store it in an NSArray instance variable in your view controller? Or an NSDictionary? How about pulling it straight out of a collection on one of your domain objects? There has to be a better way.

### A note on building the project

If you want to check the project out and build it, you'll need to make sure you initialise the project's git submodules first; it has two, Kiwi and Mocky.

* Kiwi: http://www.kiwi-lib.info/
* Mocky: http://github.com/lukeredpath/LRMocky

## A missing abstraction?

Having implemented far too many UITableViewControllers in the same repetitive fashion, I started to wonder if there was a missing abstraction that should sit between your domain model and the UITableView's data source. Something that responds to events in your domain's language (e.g. receive a new tweet, delete a contact), which may or may not be the result of user input (perhaps the Tweet arrived from the Twitter streaming API), and publishes events in response to these that speak the language of UITableView: row has been inserted, rows have been deleted etc.

## Implementing the concept of a table model

All of the work here is based on the TableModel interface that powers the Java Swing JTable API, but don't let the words Java or Swing put you off. The JTable component isn't quite the same as UITableView. It's a more traditional table component with rows representing objects and columns representing properties, with cells displaying a single value but the more I looked at it the more I felt it could be made to work with UITableView.

This project is an exploration of that concept with the hope that it might evolve into something generally useful.

## Further benefits: easier unit testing

By implementing most of your table update logic in the TableModel, with the controller simply responding to these changes by reloading the table view one way or another, it becomes possible to unit test your table model code independently of the UITableView. The SimpleTableViewModelTest test shows how easy this is, using a mock event listener.

## A brief overview of the different components

The core of LRTableModel is a series of protocols which your application needs to implement. They are:

### LRTableModel (inherits from UITableViewDataSource)

The core protocol, the missing link between UITableView and your domain. The intention is that your implementation of the LRTableModel protocol will also act as the data source for your table view. Implementations can be generic (see the SimpleTableModel example, which is based on a generic array of objects) -- in fact, it may be possible to provide an abstract implementation of the protocol that users can sub-class in the majority of cases -- although I would recommend implementing a table model that speaks that language of your domain and indeed, forms part of your domain model.

### LRTableModelCellProvider

The general pattern for providing table view cells is the same; dequeue a reusable cell, create a new one if one is not available, configure it with properties from your domain object then return it. An abstract implementation of LRTableModel should be able to encapsulate this pattern by delegating to an instance of LRTableModelProvider to fill in the blanks - creating new cells, specifying a reuse identifier and configuring a cell's properties.

### LRTableModelEventListener

This will generally be implemented by the view controller that manages the UITableView and will be used to respond to events triggered by the table model; these will be inserts, updates, deletions, refreshes (where the whole structure or data set has changed). The simplest thing the event listener could do is simply reload the UITableView but it may choose to handle different types of events with more granular updates, like animated insertions/deletions.

## Examples

The project contains the following examples:

### SimpleTableModel

A generic implementation based around an array of domain objects; this implementation is provided with unit tests and may provide the basis for some kind of abstract table model class.

## License

All code is copyright Luke Redpath 2010 and is provided under the terms of the MIT license.


