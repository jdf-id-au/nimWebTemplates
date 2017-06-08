## testsuit for nwt
## 
## Everything here should run. 
## If not its a bug!
## 
import ../nwt

var tmpls = newNwt()

block:
  tmpls.templates.add("a",""); assert tmpls.renderTemplate("a") == ""
  tmpls.templates.add("a","test"); assert tmpls.renderTemplate("a") == "test"

  when not defined release:
    tmpls.templates.add("a","{{test}}"); assert tmpls.renderTemplate("a") == "{{test}}" #
  else:
    tmpls.templates.add("a","{{test}}"); assert tmpls.renderTemplate("a") == "" #



block:
  tmpls.templates.add("base.html","{%block 'bar'%}{%endblock%}")
  tmpls.templates.add("extends.html","{%extends base.html%}{%block 'bar'%}Nim likes you{%endblock%}")
  assert tmpls.renderTemplate("extends.html") == "Nim likes you"      


block: ## Import 
  tmpls.templates.add("imp1.html","{%set 'var' 'one two three'%}{%block block1%}b1{%endblock%}")
  tmpls.templates.add("imp2.html","{%set 'var2' 'tralalala'%}{%block block2%}b2{%endblock%}")
  tmpls.templates.add("base.html","{%import imp1.html%}{{var}}")
  assert tmpls.renderTemplate("base.html") == "one two three"        

  tmpls.templates.add("base.html","{%import imp1.html%}{{var}}{{var}}")
  assert tmpls.renderTemplate("base.html") == "one two threeone two three"  


  tmpls.templates.add("base.html","{%import imp1.html%}{%import imp2.html%}{{var}}{{var2}}")
  assert tmpls.renderTemplate("base.html") == "one two threetralalala"  

  tmpls.templates.add("base.html","{%import imp1.html%}{%import imp2.html%}{{var}}{{var2}} {%block block1%}{%endblock%}{%block block2%}{%endblock%}")
  assert tmpls.renderTemplate("base.html") == "one two threetralalala b1b2"  

  tmpls.templates.add("base.html","{%import imp1.html%}{%import imp2.html%}{{var}}{{var2}} {%block block1%}{%endblock%}{%block block2%}{%endblock%}")
  assert tmpls.renderTemplate("base.html") == "one two threetralalala b1b2"  



  # TODO BUG blocks from an import gets not filled
  # tmpls.templates.add("imps.html","{%import imp1.html%}") ## this is how it should be right?
  tmpls.templates.add("imps.html","{%import imp1.html%}{%block block1%}{%endblock%}") ## WORKAROUND why is this neccesarry?
  tmpls.templates.add("base.html","{%import imps.html%}{{var}} {%block block1%}{%endblock%}")
  # tmpls.templates.add("base.html","{%import imps.html%}{{var}} {{self.block1}}")
  # echo "\n\n", tmpls.renderTemplate("base.html") ,"\n\n"
  assert tmpls.renderTemplate("base.html") == "one two three b1"


  ## TODO BUG blocks from an import gets not filled
  # tmpls.templates.add("imps.html","{%import imp1.html%}{%import imp2.html%}") ## this is how it should be right? 
  tmpls.templates.add("imps.html","{%import imp1.html%}{%import imp2.html%}{%block block1%}{%endblock%}{%block block2%}{%endblock%}") ## WORKAROUND why is this neccesarry? 
  tmpls.templates.add("base.html","{%import imps.html%}{{var}}{{var2}} {%block block1%}{%endblock%}{%block block2%}{%endblock%}")
  # echo "\n\n", tmpls.renderTemplate("base.html") ,"\n\n"
  assert tmpls.renderTemplate("base.html") == "one two threetralalala b1b2"  

  tmpls.templates.add("layout.html","{%block layout%}{%block inside1%}{%endblock%}{%block inside2%}{%endblock%}{%endblock%}")
  tmpls.templates.add("base.html","{%extends layout.html%}{%block inside1%}a{%endblock%}{%block inside2%}b{%endblock%}") # here is the ab
  tmpls.templates.add("info.html","{%import base.html%}{%block layout%}{%endblock%}")
  assert tmpls.renderTemplate("info.html") == "ab"   


block: ## self.templatename tests
  var tmpls = newNwt()
  tmpls.templates.add("imp1.html", "{%block blk1%}b1{%endblock%}")
  tmpls.templates.add("imp2.html", "{%block blk2%}b2{%endblock%}")
  tmpls.templates.add("imp3.html", "{%block blk3%}b3{%endblock%}{%block blk4%}b4{%endblock%}")
  tmpls.templates.add("run.html", "{%import imp1.html%}{{self.blk1}}")
  assert tmpls.renderTemplate("run.html") == "b1"   
  
  tmpls.templates.add("run.html", "{%import imp1.html%}{%import imp2.html%}{{self.blk1}}{{self.blk2}}")
  assert tmpls.renderTemplate("run.html") == "b1b2"   

  tmpls.templates.add("run.html", "{%import imp1.html%}{%import imp2.html%}{%import imp3.html%}{{self.blk1}}{{self.blk2}}{{self.blk3}}{{self.blk4}}")
  assert tmpls.renderTemplate("run.html") == "b1b2b3b4"   


# block: #double extends are not supported
#   tmpls.templates.add("ext1.html", "{%block ext1%}e1{%endblock%}") 
#   tmpls.templates.add("ext2.html", "{%block ext1%}e2{%endblock%}") 


