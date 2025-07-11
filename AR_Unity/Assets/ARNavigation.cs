using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class ARNavigation : MonoBehaviour
{
    public GameObject arrowPrefab;             // Your ARArrow prefab
    public Transform target;                   // Destination point
    public ARRaycastManager raycastManager;

    private GameObject arrowInstance;
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();

    void Update()
    {
        if (Input.touchCount > 0 && arrowInstance == null)
        {
            Touch touch = Input.GetTouch(0);
            if (touch.phase == TouchPhase.Began)
            {
                if (raycastManager.Raycast(touch.position, hits, TrackableType.PlaneWithinPolygon))
                {
                    Pose hitPose = hits[0].pose;
                    arrowInstance = Instantiate(arrowPrefab, hitPose.position, Quaternion.identity);
                }
            }
        }

        // Rotate arrow to face the target
        if (arrowInstance != null && target != null)
        {
            Vector3 direction = target.position - arrowInstance.transform.position;
            direction.y = 0; // Keep it flat
            if (direction != Vector3.zero)
            {
                arrowInstance.transform.rotation = Quaternion.LookRotation(direction);
            }
        }
    }
}
