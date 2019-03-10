using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AlphaMask : MonoBehaviour
{
    Image[] _images;
    [SerializeField]
    Texture2D _alphaTex;
    [SerializeField]
    Material _mat;
    RectTransform rect;
    // Start is called before the first frame update
    void Start()
    {
        rect = GetComponent<RectTransform>();
        _images = GetComponentsInChildren<Image>(true);
        foreach (var item in _images)
        {
            item.material = new Material(_mat);
        }
    }

    // Update is called once per frame
    void Update()
    {
        foreach (var item in _images)
        {
            item.material.SetTexture("_AlphaTex", _alphaTex);
            var pos = rect.worldToLocalMatrix.MultiplyVector(rect.localPosition);
            item.material.SetVector("_AlphaPos", rect.localPosition);
            item.material.SetFloat("_Width" , rect.sizeDelta.x * rect.lossyScale.x);
            item.material.SetFloat("_Height", rect.sizeDelta.y * rect.lossyScale.y);

            Debug.Log(transform.lossyScale);
        }
    }
}
