Target: blueprint/src/chapters/Picard_TensorObjSubstrate.tex (just writer-edited: `lem:slice_dual_transport_inv` prose + `lem:sheafify_tensor_unit_iso_comp` proof `\uses{}`).

Action: post-write purity pass on the edited regions. Strip any Lean tactic syntax / project-history
narrative / verbosity that leaked in; confirm the new `hβ` hypothesis prose, the corrected step-(b)
naturality reference (sliceDualTransport_naturality_apply + appIso_hom_naturality_apply +
dualUnitRingSwap_apply), and the added `unitRelabelSwap` 4th leg read as mathematical prose, not Lean.
Validate source quotes are intact. Do NOT touch `\leanok`/`\mathlibok` markers.
