# Trellosnap

```
NOTE: This is a work in progress. The extension does not yet work.
```

This is a Chrome Extension that will help with the task of bug reporting. It allows you to take screenshots of a website page or custom selection - all of this can be annotated and edited before getting uploaded to Trello to a board of your choosing.

### Development Setup

This extension is built using both ruby and node technologies. The following instructions assume that you have both Rails and Node (with NPM) installed.

- Clone
- Run `gem install bundler`
- Run `npm install -g coffee-script`
- Run `npm install -g jade@1.8.1`
- Run `bundle`
- Run `foreman start`
- Tweak code within the `src` folders


### Timeline

###### 01-14-15

Finished the partial screenshot selection tool.

![http://clrsight.co/yg/011415-04huv.gif?+](http://clrsight.co/yg/011415-04huv.gif?+)

###### 01-13-15

Currently working on the partial page screenshot selection. There are no lightweight libraries out there that will do that; therefore, writing a custom solution.

###### 01-10-15

Hooked up event to capture visible page and send the image to an 'edit' screen. Styled the Browser Action:

![http://clrsight.co/yg/011015-x2ltt.jpg?+](http://clrsight.co/yg/011015-x2ltt.jpg?+)

###### 01-08-15

Set up project. File organization. Started throwing together needed files etc.