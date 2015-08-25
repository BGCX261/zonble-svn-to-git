class UI {
	var Vars:LoadVars; //外部傳入參數
	var total:Number; //全部照片
	var current:Number; //目前所在的照片
	var images:Array; //照片資料陣列
	var audio:Sound; //播放用的聲音物件
	var audioposition:Number; //目前聲音播放到什麼地方
	var totaltime:Number; //全部時間
	var interval:Number; //播放頻率
	var title:String; //標題
	var autoplaying:Boolean = false; //是否正在自動播放
	var playing:Boolean = false; //是否正在播放聲音
	var playfinish:Boolean = false; //已經播放完畢
	var pause:Boolean = false;
	var baseurl:String= "";
	var runAutoplay;
	var runTime;
	var fademode:Boolean = false; //Fading in or fading out	var fade; //the id of fading
	
	function timeFormat(time:Number){			var time = Math.floor(time/1000);		if(!time) return "";		var min = Math.floor(time/60);		var sec = Math.floor(time % 60);		if (min<10) { min = "0" + min;}			if (sec<10) { sec = "0" + sec;}		return min + ":"  + sec;	}
	
	function timeString() {
		 return this.timeFormat(this.audio.position) + "/" + this.timeFormat(this.totaltime);
	}	

	/* 照片相關 */

	function showPhoto(){
		var Photo = this.images[this.current];
		trace("Current Photo: "+this.current);
		return Photo;
	}

	function showAuto(){
		if(this.pause) {
			this.pause = false;
			return false;
		}
		if(this.autoplaying){
			++this.current;
			if(this.current > this.total ) { this.current = this.total; }
			return true;
		}
		return false;
	}	

	function showPrev():Boolean{
		this.current--;
		if(this.current < 1 ) { this.current = 1; return false;}
		this.autoplaying = false;
		this.pause = true;		
		return true;
	}

	function showNext():Boolean{
		this.current++;
		if(this.current > this.total ) { this.current = this.total; return false; }
		this.autoplaying = false;
		this.pause = true; 
		return true;
	}
	
	function LoadPhoto(){
		this.total = parseInt(this.Vars.totalpics);
		this.title = this.Vars.title;
		var i:Number;
		this.images = new Array();
		for(i = 1; i <= this.total; i++) {
			var Photo = new myPhoto();
			Photo.setImage(this.baseurl + "photo"+i+".jpg");
			Photo.setCaption(this.Vars["caption"+i]);
			Photo.setCredit(this.Vars["credit"+i]);
			this.images[i]=Photo;
		}
	}
	
	/* 聲音相關 */
	
	function playSound() {
		if(this.audioposition > 0 && this.audioposition < this.totaltime) {
			this.audio.start(Math.floor(this.audioposition / 1000), 0);
		} else {
			this.audio.start();
			this.playfinish = false;
		}
		this.playing = true;
	}

	function stopSound() {
		this.audioposition = this.audio.position;
		this.pause = true;
		this.audio.stop();
		this.playing = false;		
	}
	
	function stopAutoplay() {
		clearInterval(this.runAutoplay);		this.autoplaying = false;
	}
	
	function playFinished(){
		this.playfinish = true;	
		this.playing = false;
		this.autoplaying = false;
		this.current = 1;
	}

	function playEnd() {
		if(this.audio.position == this.totaltime) {
			return true;
		}
		else return false;
	}
	
	function setInterval(){
		this.interval = Math.floor(this.totaltime / (this.total));
	}

	function getInterval():Number{
		if(this.interval) {return this.interval;} 
		else { return 3000;}
	}

	function barWidth(w, x):Number{
		var rtn:Number;
		if(!w) {return x;}
		rtn =  (x+ (this.current - 1) * (w/(this.total -1)));
		return rtn;
	}
	
	function barCurrent(x, w):Boolean {
		var current:Number = Math.round(x / (w/(this.total -1))) + 1;
		if(current != this.current) {
			this.current = current;
			return true;
		}
		return false;
	}

	function init(Vars:LoadVars, baseurl:String){
		this.baseurl = baseurl;
		this.Vars = Vars;
		this.LoadPhoto();
		this.autoplaying = true;
		this.current = 0;
		this.audioposition = 0;
		this.audio = new Sound();
		this.audio.loadSound("audio.mp3", true);
	}
}
