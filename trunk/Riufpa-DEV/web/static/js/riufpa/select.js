/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


document.observe("dom:loaded", function() {
    var els= $$('select');
    for (var i=0; i<els.length; i++){
        if(els[i].readAttribute('multiple') === 'multiple'){
            continue;
        }

        var myDiv = new Element("span");
        myDiv.addClassName("css3-selectbox");
        if(!els[i].visible()){
            myDiv.writeAttribute("style", "display:none");
        }
        els[i].wrap(myDiv);
    }
});