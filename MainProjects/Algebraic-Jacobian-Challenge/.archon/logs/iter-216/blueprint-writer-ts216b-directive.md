# Blueprint-writer directive — iter-216b — chapter consistency demotion

## Context
A prior writer pass (ts216) re-routed the associator `lem:tensorobj_assoc_iso` to the direct gluing construction (via `tensorObj_restrict_iso` + canonical presheaf associator + Hom-sheaf gluing) and marked seven route-(e) blocks as superseded. The mathlib-analogist (`analogies/ts-picard-direct-216.md`) established that the ⊗-group law on iso-classes needs ONLY existence of the assoc/unit/braiding isos (à la `CommRing.Pic`/`monoidOfSkeletalMonoidal`), so the whole route-(e) `LocalizedMonoidal`/`(J.W).IsMonoidal`/stalk/d.2 apparatus is VESTIGIAL.

The prior writer noted three EARLIER narrative sections still present route-(e) as THE way to obtain the monoidal structure, which now contradicts the pivot.

## Required edits to `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (these sections ONLY)

1. `sec:tensorobj_motivation` (≈L86–135) — demote any framing that presents the full monoidal category / `LocalizedMonoidal` as the goal. State the goal is the commutative GROUP on locally-trivial iso-classes (à la `CommRing.Pic`), which needs only existence-of-iso, NOT a coherent monoidal category.
2. `sec:tensorobj_api_survey` (≈L136–279) — where it frames `J.W.IsMonoidal` as "the sole genuinely-new obligation" or route-(e) as the cheap path, demote it: note that approach is SUPERSEDED; the group law never requires `(J.W).IsMonoidal`, and the associator is obtained by direct gluing through `tensorObj_restrict_iso`.
3. `rem:scheme_modules_monoidal_off_path` (≈L370–423) — reconcile with the supersession: the monoidal-category-on-all-of-`SheafOfModules` is explicitly OFF-PATH and not pursued; the substrate provides only the existence-of-iso the group law consumes.
4. `lem:tensorobj_unit_iso` proof prose — drop the route-(e) "equivalently ... components of the route-(e) monoidal structure" alternative clause; keep the primary `mapIso` route.

Keep edits surgical: demote/redirect the route-(e) promotion to be consistent with the direct-gluing associator and the supersession banners. Do NOT alter the load-bearing lemma blocks already rewritten (`lem:tensorobj_assoc_iso`, `lem:tensorobj_restrict_iso`, `lem:tensorobj_isoclass_commgroup`, `lem:restrictscalars_ringiso_tensorequiv`). Do NOT touch `\leanok`/`\mathlibok`. Do NOT edit other chapters.

## Citation discipline
Mathlib decls may be cited by path+name. Do not fabricate verbatim source quotes.
