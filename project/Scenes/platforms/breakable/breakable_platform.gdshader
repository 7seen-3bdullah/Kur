shader_type canvas_item;

uniform bool Shake = true;
uniform float amplitude: hint_range(0.0, 1.0);
uniform float speed: hint_range(0.0, 2.0);
uniform bool X_shake = true;
uniform bool Y_shake = true;
void vertex() {
	if(Shake){
		float time = TIME * (30. * speed);
		float wobbling = sin(time) * 40. * amplitude;
		float direction = sin(time / 2.);
		
		if(X_shake && Y_shake){
			VERTEX += vec2(direction * wobbling,wobbling);
		}
		else{
			
			if(X_shake && !Y_shake){
				VERTEX += vec2(direction * wobbling,0.0);
			}
			if(!X_shake && Y_shake){
				VERTEX += vec2(0,wobbling);
			}
			}
		
	}
}