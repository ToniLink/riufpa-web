/**
SelectReplace class

author: Atanas Markov
author site: http://awsumlabs.com
e-mail: dreamer79@mail.bg

License: You can modify, distribute, use this code as long as you provide my contact information and information that I'm the author of the original code.
*/


var SelectReplace= Class.create({

    initialize: function(select, options) {

        if (typeof select=='string'){
            this.select= $(select);
        } else {
            this.select= select;
        }

        this.lastval=0;

        this.options= Object.extend(Object.extend({ }, SelectReplace.DefaultOptions), options || { });


        this.selectdiv= document.createElement('div');
        this.selectdiv.className= this.options.selectclass;
        this.selectdiv.style.width= (this.getElementWidth(this.select)+10)+'px';
        //this.selectdiv.style.height= this.getElementHeight(this.select)+'px';

        var tmp = Element.cumulativeOffset(this.select);
        this.select.style.visibility= 'hidden';


        var x = tmp[0];
        var y = tmp[1] - 7;

        this.selectdiv.style.position='absolute';
        this.selectdiv.style.top= y+'px';
        this.selectdiv.style.left= x+'px';
        this.selectdiv.style.display= 'block';

        document.body.appendChild(this.selectdiv);

        this.selectdivinner= document.createElement('div');
        this.selectdivinner.className= this.options.selectinnerclass;

        this.selectdivfoo= document.createElement('div');
        this.selectdivfoo.style.display= 'block';
        this.selectdiv.appendChild(this.selectdivfoo);
        this.selectdivfoo.appendChild(this.selectdivinner);

        this.selectdivbtn= document.createElement('div');
        this.selectdivbtn.className= this.options.selectbuttonclass;
        this.selectdivfoo.style.height= this.getElementHeight(this.selectdiv) + 'px';
        this.selectdivfoo.appendChild(this.selectdivbtn);

        this.selectdiv.observe('click',this.toggleSelect.bind(this));

        this.selectoptionsdiv= document.createElement('div');
        this.selectoptionsdiv.className= this.options.selectboxclass;
        this.selectoptionsdiv.style.visibility= 'hidden';
        this.selectoptionsdiv.style.display= '';

        if (this.options.selectboxautowidth){
            this.selectoptionsdiv.style.width= this.getElementWidth(this.selectdiv)+'px';
        }

        document.body.appendChild(this.selectoptionsdiv);



        this.selectholder= document.createElement('div');

        this.selectoptionsfoo= document.createElement('div');
        this.selectoptionsfoo.style.width= this.getElementWidth(this.selectoptionsdiv) + 'px';
        this.selectoptionsfoo.style.display= 'block';
        this.selectoptionsfoo.style.overflow= 'hidden';
        this.selectoptionsfoo.style.position= 'relative';

        this.selectoptionsdiv.appendChild(this.selectoptionsfoo);
        this.selectoptionsfoo.appendChild(this.selectholder);

        this.selopts= new Array();
        this.curel= 0;

        // makes the title of the component the value of the selected item.
        this.selectdiv.setAttribute('title', this.select.options[this.select.selectedIndex].text);
        for (var i=0;i<this.select.options.length;i++){
            this.selopts[i]= document.createElement('div');
            this.selopts[i].setAttribute('value',this.select.options[i].value);
            this.selopts[i].setAttribute('title',this.select.options[i].text);
            this.selopts[i].className= this.options.selectoptionclass;

            if (typeof this.select.options[i].getAttribute('imgsrc')!='undefined'&&this.select.options[i].getAttribute('imgsrc')!=null&&this.select.options[i].getAttribute('imgsrc')!=''){
                var newimg= document.createElement('img');
                newimg.src= this.select.options[i].getAttribute('imgsrc');
                newimg.className= this.options.selectoptionimgclass;
                this.selopts[i].appendChild(newimg);
            }

            this.selopts[i].innerHTML= this.selopts[i].innerHTML + this.select.options[i].text;
            if(this.selopts[i].innerHTML == '' || this.selopts[i].innerHTML == null){
                this.selopts[i].innerHTML = "<i>Escolha uma opção</i>";
            }
            this.selopts[i].setAttribute('selindex',i);

            if (this.select.options[i].selected){
                this.selopts[i].className= this.options.selectoptionselclass;
                this.curel= i;
            }

            this.selopts[i].observe('click',this.optionClick.bind(this));
            //this.selopts[i].observe('dblclick',this.optionDblClick.bind(this));

            this.selectholder.appendChild(this.selopts[i]);
        }



        if (this.options.perscroll > this.selopts.length){
            this.options.perscroll = this.selopts.length;

        }

        this.elemheight= 0;
        if (this.selopts.length>0){
            this.elemheight = this.getElementHeight(this.selopts[0]);
        }

        if (!this.options.hidescroll||this.options.perscroll<this.selopts.length){
            this.scrolldiv= document.createElement('div');
            this.scrolldiv.className= this.options.selectscrollclass;
            this.scrolldiv.style.position= 'absolute';
            this.scrolldiv.style.top= '0px';
            this.scrolldiv.style.right= '0px';
            this.scrolldiv.style.height= this.elemheight * this.options.perscroll+'px';
            this.selectoptionsfoo.appendChild(this.scrolldiv);

            this.scrolldivfoo= document.createElement('div');
            this.scrolldivfoo.style.position='relative';
            this.scrolldivfoo.className='selreplace_scrollinner_cont';
            this.scrolldiv.appendChild(this.scrolldivfoo);

            this.scrollbtnup= document.createElement('a');
            this.scrollbtnup.className= this.options.selectscrollbuttonupclass;
            this.scrolldivfoo.appendChild(this.scrollbtnup);
            this.scrollbtnup.observe('click',this.moveUp.bind(this));


            this.scrolldivinner= document.createElement('div');
            this.scrolldivinner.className= this.options.selectscrollinnerclass;
            this.scrolldivfoo.appendChild(this.scrolldivinner);


            this.scrollbtndn= document.createElement('a');
            this.scrollbtndn.className= this.options.selectscrollbuttondownclass;
            this.scrolldivfoo.appendChild(this.scrollbtndn);
            this.scrollbtndn.observe('click',this.moveDown.bind(this));

            this.scrollhandle= document.createElement('div');
            this.scrollhandle.className= this.options.selectscrollhandleclass;
            this.scrolldivinner.appendChild(this.scrollhandle);

            this.selectoptionsfoo.style.height= this.elemheight * this.options.perscroll + 'px';

            this.scrolldivinner.style.height= this.getElementHeight(this.selectoptionsfoo)-this.getElementHeight(this.scrollbtndn)-this.getElementHeight(this.scrollbtnup) + 'px';

            this.slider= new Control.Slider([this.scrollhandle], this.scrolldivinner, {
                range: $R(0, this.selopts.length-this.options.perscroll),
                values: $R(0, this.selopts.length-this.options.perscroll),
                sliderValue: [0],
                axis: 'vertical',
                restricted: true,
                onSlide: this.slide.bind(this),
                onChange: this.slide.bind(this)
            });

        }

        this.selectoptionsdiv.style.display='none';
        this.selectoptionsdiv.style.visibility='visible';

        this.setCurVal(this.curel);
        selectreplacecol.add(this);
    },

    clickedOutside: function (e){
        var item = Event.element(e);
        //alert(item);
        if (!item.up('.selreplace_select') && !item.up('.selreplace_selectbox')){
            this.curel= this.curopt;
            this.select.selectedIndex= this.curopt;
            this.toggleSelect.bind(this)(e);
            this.setCurVal(this.curel);
            e.stop();
        }
    },

    toggleSelect: function (e){
        e.stop();

        var tmp = Element.cumulativeOffset(this.selectdiv);

        var x = tmp[0];
        var y = tmp[1];

        this.selectoptionsdiv.style.position='absolute';
        this.selectoptionsdiv.style.top=y+this.selectdiv.offsetHeight+'px';
        this.selectoptionsdiv.style.left=x+'px';

        if (this.selectoptionsdiv.style.display=='none'){
            this.curopt= this.select.selectedIndex;

            for (var i=0;i<this.select.options.length;i++){
                this.selopts[i].className= this.options.selectoptionclass;
                if (this.select.options[i].selected){
                    this.selopts[i].className= this.options.selectoptionselclass;
                    this.curel= i;
                }
            }

            new Effect.Appear(this.selectoptionsdiv,{
                duration: this.options.effectduration
                });
            document.observe('keydown', this.observeKeyDown.bind(this));
            document.observe('click', this.clickedOutside.bind(this));

            this.selectoptionsdiv.observe('mousewheel',this.scrollList.bind(this));
            this.selectoptionsdiv.observe('DOMMouseScroll',this.scrollList.bind(this));

            //Event.observe(this.selectdiv, "mousewheel", this.scrollList, false);
            //Event.observe(this.selectdiv, "DOMMouseScroll", this.scrollList, false); // Firefox

            selectreplacecol.hideAll();
            if (this.curel<=this.selopts.length-this.options.perscroll){
                this.slide(this.curel);
            } else {
                this.slide(this.selopts.length-this.options.perscroll);
            }
        } else {
            new Effect.Fade(this.selectoptionsdiv,{
                duration: this.options.effectduration
                });
            document.stopObserving('keydown');
            document.stopObserving('click');
        }
    },

    scrollList: function(e){
        var direction = Event.wheel(e);
        e.stop(); // Avoids browser from interpreting this scroll command.
        if (direction > 0){
            this.moveUp();
        } else {
            this.moveDown();
        }
    },

    getElementHeight: function(element) {
        if (typeof element.clip !== "undefined") {
            return element.clip.height;
        } else {
            if (typeof element.style!=='undefined'&&element.style.pixelHeight) {
                return element.style.pixelHeight;
            } else {
                if (element.offsetHeight){
                    return element.offsetHeight;
                } else {
                    return element.clientHeight;
                }
            }
        }
    }
    ,
    getElementWidth:function(element) {
        if (typeof element.clip !== "undefined") {
            return element.clip.width;
        } else {
            if (typeof element.style!=='undefined'&& element.style.pixelWidth) {
                return element.style.pixelWidth;
            } else {
                if (element.offsetWidth){
                    return element.offsetWidth;
                } else {
                    return element.clientWidth;
                }
            }
        }
    }
    ,
    hide: function(){
        if (this.selectoptionsdiv.style.display!='none'){
            new Effect.Fade(this.selectoptionsdiv,{
                duration: this.options.effectduration
                });
            document.stopObserving('keydown');
        }
    }
    ,
    observeKeyDown: function(e){

        switch(e.keyCode) {
            case Event.KEY_UP:
                e.stop();
                if (this.curel>0) {
                    this.curel--;
                    this.setCurVal(this.curel);
                }
                return false;
            case Event.KEY_DOWN:
                e.stop();
                if (this.curel<this.selopts.length-1) {
                    this.curel++;
                    this.setCurVal(this.curel);
                }
                return false;
            case Event.KEY_RETURN:
                this.select.selectedIndex= this.curel;
                this.toggleSelect.bind(this)(e);
                this.setCurVal(this.curel);
                e.stop();
                break;
            case Event.KEY_ESC:
                this.curel= this.curopt;
                this.select.selectedIndex= this.curopt;
                this.toggleSelect.bind(this)(e);
                this.setCurVal(this.curel);
                e.stop();
                break;
        }
    },
    setCurVal: function(value){
        var els= this.selopts;
        this.curel= value;
        for (var i=0; i<els.length;i++){
            els[i].className= this.options.selectoptionclass;
        }
        els[this.curel].className= this.options.selectoptionselclass;
        this.select.selectedIndex= value;
        this.selectdivinner.innerHTML= this.selopts[value].innerHTML;

        if (typeof this.slider!='undefined'&&this.slider!=null){
            if (this.curel<this.selopts.length){
                if (this.slider.value>this.curel||this.slider.value+this.options.perscroll<=this.curel){
                    if (this.curel<=this.selopts.length-this.options.perscroll){
                        this.slide(this.curel);
                    } else {
                        this.slide(this.selopts.length-this.options.perscroll);
                    }
                }
            }
        }
    },
    optionClick: function(e){
        var element= Event.element(e);
        var index = element.getAttribute('selindex');
        this.setCurVal(index);
        //Hide selection list even if an item is clicked once.
        this.select.selectedIndex= this.curel;
        this.toggleSelect.bind(this)(e);

        this.selectdiv.setAttribute('title', this.selopts[index].innerHTML);
    },
    optionDblClick: function(e){
        var element= Event.element(e);
        this.setCurVal(element.getAttribute('selindex'));
        this.select.selectedIndex= this.curel;
        this.toggleSelect.bind(this)(e);
    },
    slide: function (value){
        if (this.lastval!=value){
            var hh= this.elemheight*value;
            new Effect.Move(this.selectholder,{
                x:0,
                y:-hh,
                mode:'absolute',
                duration:0.2
            });
            this.lastval= value;
            this.slider.setValue(value);
        }
    },
    moveUp: function () {
        if (this.slider.value > 0){
            this.slider.setValue(this.slider.value - 1);
        }
    }
    ,
    moveDown: function () {
        if (this.slider.value < this.selopts.length - this.options.perscroll){
            this.slider.setValue(this.slider.value + 1);
        }
    }
});

var SelectReplaceCol= Class.create({
    initialize: function(){
        this.sels= new Array();
    }
    ,
    hideAll: function (){
        for (var i=0; i<this.sels.length; i++){
            this.sels[i].hide();
        }
    }
    ,
    add: function (element){
        this.sels[this.sels.length]= element;
    }
});

SelectReplace.DefaultOptions = {
    selectclass: 'selreplace_select',
    selectinnerclass: 'selreplace_selectinner',
    selectbuttonclass: 'selreplace_selectbutton',
    selectboxclass: 'selreplace_selectbox',
    selectscrollclass: 'selreplace_scroll',
    selectscrollinnerclass: 'selreplace_scrollinner',
    selectscrollbuttonupclass: 'selreplace_scrollbuttonup',
    selectscrollbuttondownclass: 'selreplace_scrollbuttondown',
    selectscrollhandleclass: 'selreplace_scrollhandle',
    selectoptionclass: 'selreplace_option',
    selectoptionimgclass: 'selreplace_optionimg',
    selectoptionselclass: 'selreplace_optionsel',
    selectappeareffect: 'Appear',
    selectfadeeffect: 'Fade',
    perscroll: 10,
    effectduration: 0.2,
    moveduration: 0.2,
    hidescroll: true,
    selectboxinnerclass: 'selreplace_selectboxinner',
    selectboxautowidth: true
};


/*
 * Orginal: http://adomas.org/javascript-mouse-wheel/
 * prototype extension by "Frank Monnerjahn" <themonnie@gmail.com>
 */
Object.extend(Event, {
    wheel:function (event){
        var delta = 0;
        if (!event) event = window.event;
        if (event.wheelDelta) {
            delta = event.wheelDelta/120;
            if (window.opera) delta = -delta;
        } else if (event.detail) {
            delta = -event.detail/3;
        }
        return Math.round(delta); //Safari Round
    }
});



var selectreplacecol= new SelectReplaceCol();

document.observe("dom:loaded", function() {
    //var els= document.body.getElementsByClassName('replacemeselect');

    var els= $$('select');

    for (var i=0; i<els.length; i++){
        if (els[i].tagName.toLowerCase()=='select' || els[i].readAttribute('multiple') != 'multiple' || !els[i].readAttribute('multiple')){
            new SelectReplace(els[i],{});
        }
    }
});

/*
	You can call the class manually using:

	var el= new SelectReplace('selectid',{options});

	By manual calls you can override the default options, but in a project in most cases you'll just have to set your own default options and set your selects class to "replacemeselect".
*/
