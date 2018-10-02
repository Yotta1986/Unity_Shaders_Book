using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderCubemapWizard: MonoBehaviour {

	public Transform renderFromPosition;
	public Cubemap cubemap;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

	public void onWizardCreate()
	{
		GameObject go = new GameObject("CubemapCamera");
		go.AddComponent<Camera>();
		go.transform.position = renderFromPosition.position;
		go.GetComponent<Camera>().RenderToCubemap(cubemap);
		DestroyImmediate(go);
	}
}
