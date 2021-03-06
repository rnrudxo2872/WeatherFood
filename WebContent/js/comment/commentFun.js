import { UpdateCommentFunc, DeleteCommentFunc } from "./userInter.js"

export const commentUser = document.querySelector("#user_id").value;
export const commentListHead = document.querySelector(".commentList-head");
const commentForm = document.querySelector(".comment-container__form");
const commentInput = document.querySelector("#userComment");
const commentList = document.querySelector(".comment-container__commentList");
const footer =  document.querySelector('.footer-container');
const commentBoardNum = document.querySelector("#board_num").value;

const CommentFunc = {
		Update : UpdateCommentFunc,
		Delete : DeleteCommentFunc
} 

let count = 0;

let insertCommentHead = async() =>{
	let numberOfComment = await (await fetch(`../getNumberOfComment.json?num=${commentBoardNum}`).catch(err)).text()

	if(numberOfComment == 1)
	    commentListHead.innerText = `1 comment`;
	else
		commentListHead.innerText = `${numberOfComment} comments`;
}


let insertCommentButton = (idx) => {
	let btnContainer = document.createElement("span");

	let update = document.createElement("a");
	let del = document.createElement("a");
	update.setAttribute("href", `./updateComment?idx=${idx}`);
	del.setAttribute("href", `./delComment?idx=${idx}`);
	
	update.id = "comment__update";
	del.id = "comment__delete";
	
	update.innerText = "수정";
	del.innerText = "삭제";
	
	update.style.marginLeft = "10px";
	update.style.marginRight = "10px";
	
	update.addEventListener("click", CommentFunc.Update)
	del.addEventListener("click", CommentFunc.Delete);

	btnContainer.appendChild(update);
	btnContainer.appendChild(del);

	return btnContainer;
}

let insertHtml = (commentsJson, insert) =>{
	if(commentsJson !== null){
		commentsJson.forEach(element =>{
			console.log(element)
		    let commenttail = document.createElement("div");
		    commenttail.setAttribute("class","commentList-tail");
		    console.log(element);
		    commenttail.setAttribute("data-id",element.idx);
		    
		    let userName = document.createElement("div");
		    userName.setAttribute("class","commentUserName");
		    userName.innerText = element.user_id;

		    let date = document.createElement("div");
		    date.setAttribute("class","commentDate");
		    date.innerText = element.date == undefined ? '방금' : element.date;

		    let commentContent = document.createElement("div");
		    commentContent.setAttribute("class","commentContent");
		    commentContent.innerText = element.comment;
		    
		    if(commentUser === element.user_id){
		    	let tempElement = insertCommentButton(element.idx);
		    	commentContent.appendChild(tempElement);
		    }

		    commenttail.appendChild(userName);
		    commenttail.appendChild(date);
		    commenttail.appendChild(commentContent);
		    
		    if(insert){
		    	commentList.prepend(commenttail);
		    }else{
		    	commentList.appendChild(commenttail);
		    }
		})
	}
	
}

let insertComment = async() =>{
	
	let data = {
			user_id:commentUser,
			comment:commentInput.value,
			board_num:commentBoardNum
	}
	
	let fetchData = {
		    method: 'POST',
		    body: JSON.stringify(data),
		    headers: {
		        'Content-Type': 'application/json'
		   }
	}
	
	commentInput.value = "";
	
	let commentsJson = await (await fetch("../insertComment.json",fetchData)).json();

	insertHtml(commentsJson, true);
	insertCommentHead();
}

let FetchInsert = (event) =>{
	event.preventDefault();
	if(confirm("덧글을 작성하시겠습니까?")){
		
		insertComment()
	}
}

const bottomObserver = new IntersectionObserver(targetSearch,{threshold: 1.0});
bottomObserver.observe(footer);

const initFetch = async() =>{
	
	let commentsJson = await (await fetch(`../curBoardComments.json?num=${commentBoardNum}&start=${count}`).catch(err)).json();
	
	count += 5;
	insertHtml(commentsJson);
	console.log(commentsJson)
	if(commentsJson == null){
		bottomObserver.unobserve(footer);
	}
}

function targetSearch(entries){
    entries.forEach(element => {
    	console.log(element.isIntersecting)
        if (!element.isIntersecting)
            return;
        initFetch();
    });
}

let err = (errorArgs) => {
	console.log(errorArgs);
	let res = new Response();
	alert("댓글 파싱 에러!");
	return res;
}

insertCommentHead();

if(commentForm !== null)
	commentForm.addEventListener("submit",FetchInsert);