var height = 0;

function resizeChoosed (mode) {
    
    var divChoosed = document.getElementById("choosed");
    var divBox = document.getElementById("sign_box");

    if (height == 0 ) {
        height =  document.getElementById ("meme").clientHeight;
    }

    if (isChrome() )
    {
        divChoosed.style.height = (height + 30 ) + 'px';
        divBox.style.height = (height + 120 ) +  'px';
    }
    else
    {
        divChoosed.style.height = (height + 50 ) + 'px';
        divBox.style.height = (height + 110 ) +  'px';
            
    }

    if(mode == 0 ) {       
        var txtCode = document.getElementById("txtcode");
        
        var width = divBox.clientWidth;
        if (isChrome() ) {
            txtCode.cols = Math.round (width /11);
            txtCode.rows = Math.round (height /13);
            txtCode.style.resize= disabled;
        }
        else
        {
            txtCode.cols = Math.round (width /10.5);
            txtCode.rows = Math.round (height /16);
        }
        divChoosed.style.border= "none";
        divChoosed.style.backgroundColor= "transparent";
    }
    else
    {
        divChoosed.style.border= "1px solid #696969";
        divChoosed.style.backgroundColor= "White";
    }
    
}

function isChrome () {
    return navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
}

function selectOption (component) {
    if (component.id == "li0") {
        component.className="active";
        document.getElementById("li1").className="";
    }
    else
    {
        component.className="active";
        document.getElementById("li0").className="";
    }
    
}

function copyCode () {
    var s = document.getElementById("txtcode").value;
    var text_encoded = encodeURIComponent(s);

    var flashcopier = "flashcopier";

    if(!document.getElementById(flashcopier)) {
        var divholder = document.createElement("div");
        divholder.id = flashcopier;
        document.body.appendChild(divholder);
    }

    document.getElementById(flashcopier).innerHTML = "";
    var divinfo = "";
    document.getElementById(flashcopier).innerHTML = divinfo;

	
}
