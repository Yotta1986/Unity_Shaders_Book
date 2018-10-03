using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralTextureGeneration_10_4_3 : MonoBehaviour {

	public Material material;
	private Texture2D m_generatedTexture;

	[SerializeField, SetProperty("textureWidth")]
	private int m_textureWidth = 512;
	public int textureWidth{
		get{
			return m_textureWidth;
		}
		set{
			m_textureWidth = value;
			_UpdateMaterial();
		}
	}

	[SerializeField, SetProperty("backgroundColor")]
	private Color m_backgroundColor;
	public Color backgroundColor{
		get{
			return m_backgroundColor;
		}
		set{
			m_backgroundColor = value;
			_UpdateMaterial();
		}
	}

	[SerializeField, SetProperty("circleColor")]
	private Color m_circleColor;
	public Color circleColor{
		get{
			return m_circleColor;
		}
		set{
			m_circleColor = value;
			_UpdateMaterial();
		}
	}

	[SerializeField, SetProperty("blurFactor")]
	private float m_blurFactor = 2.0f;
	public float blurFactor{
		get{
			return m_blurFactor;
		}
		set{
			m_blurFactor = value;
			_UpdateMaterial();
		}
	}

	// Use this for initialization
	void Start () {
		if(material == null)
		{
			Renderer renderer = gameObject.GetComponent<Renderer>();
			material = renderer.sharedMaterial;
		}

		_UpdateMaterial();
	}

	private void _UpdateMaterial()
	{
		if(material != null)
		{
			m_generatedTexture = _GenerateProceduralTexture();
			material.SetTexture("_MainTex", m_generatedTexture);
		}
	}

	private Texture2D _GenerateProceduralTexture()
	{
		Texture2D ProceduralTexture = new Texture2D(textureWidth, textureWidth);

		float circleInterval = textureWidth /4.0f;
		float radius = textureWidth/10.0f;
		float edgeBlur =  1.0f /blurFactor;

		for(int w=0; w<textureWidth; w++)
		{
			for(int h=0; h<textureWidth; h++)
			{
				_MixColor()
			}
		}

		return ProceduralTexture;
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
