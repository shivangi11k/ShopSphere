using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;
using System.Collections.Generic;

public class TapToPlace : MonoBehaviour
{
    [Header("Prefabs to Place")]
    public List<GameObject> modelPrefabs; // Set these in Inspector

    [Header("AR Managers")]
    public ARRaycastManager raycastManager;
    public ARPlaneManager planeManager;

    private GameObject selectedModelPrefab;   // Selected prefab by user
    private GameObject spawnedObject;         // Only one at a time
    private List<ARRaycastHit> hits = new List<ARRaycastHit>();

    private TrackableId lockedPlaneId;
    private bool planeLocked = false;

    // 🧠 Called from buttons to select which model to place
    public void SelectModel(int index)
    {
        if (index >= 0 && index < modelPrefabs.Count)
        {
            selectedModelPrefab = modelPrefabs[index];
            spawnedObject = null;  // Reset placed object when model changes
            planeLocked = false;   // Allow new plane detection for new model
            EnableAllPlanes();     // Reactivate plane tracking
            planeManager.detectionMode = PlaneDetectionMode.Horizontal;
        }
    }

    void Update()
    {
        if (Input.touchCount == 0 || selectedModelPrefab == null) return;

        Touch touch = Input.GetTouch(0);

        if (touch.phase != TouchPhase.Began) return;

        if (UnityEngine.EventSystems.EventSystem.current.IsPointerOverGameObject(touch.fingerId)) return; // Ignore UI clicks

        if (raycastManager.Raycast(touch.position, hits, TrackableType.PlaneWithinPolygon))
        {
            Pose hitPose = hits[0].pose;
            ARPlane hitPlane = planeManager.GetPlane(hits[0].trackableId);

            // Lock to one plane
            if (!planeLocked)
            {
                lockedPlaneId = hitPlane.trackableId;
                planeLocked = true;

                // Deactivate other planes
                foreach (var plane in planeManager.trackables)
                {
                    if (plane.trackableId != lockedPlaneId)
                        plane.gameObject.SetActive(false);
                }

                // Stop detecting new planes
                planeManager.detectionMode = PlaneDetectionMode.None;
            }

            // Only allow placement on locked plane
            if (hitPlane.trackableId == lockedPlaneId)
            {
                if (spawnedObject == null)
                {
                    spawnedObject = Instantiate(selectedModelPrefab, hitPose.position + new Vector3(0, 0.05f, 0), hitPose.rotation);
                }
                else
                {
                    spawnedObject.transform.position = hitPose.position + new Vector3(0, 0.05f, 0);
                    spawnedObject.transform.rotation = hitPose.rotation;
                }
            }
        }
    }

    // 🔁 Helper to re-enable all planes
    private void EnableAllPlanes()
    {
        foreach (var plane in planeManager.trackables)
        {
            plane.gameObject.SetActive(true);
        }
    }

    // 🗑️ Delete the currently placed model
    public void DeletePlacedModel()
    {
        if (spawnedObject != null)
        {
            Destroy(spawnedObject);
            spawnedObject = null;
        }
    }
}
