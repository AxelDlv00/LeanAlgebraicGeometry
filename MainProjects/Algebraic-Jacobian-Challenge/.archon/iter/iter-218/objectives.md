# Iter-218 objectives (detail)

## Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: prove]

Blueprint: `chapters/Picard_TensorObjSubstrate.tex`. Build GREEN entering; project sorry 80.

### PRIMARY — `exists_tensorObj_inverse` (L1375)  [critical path → group law]

Signature (existing sorry):
```
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)
```

Math (blueprint `lem:tensorobj_inverse_invertible`, enriched ts218; Stacks 01CR dual+contraction):
- `Linv := Hom_{O_X}(L, O_X)` (the dual sheaf). It is locally trivial: on a trivialising `U` where
  `L|_U ≅ O_U`, `Hom(L,O_X)|_U ≅ Hom(O_U, O_U) ≅ O_U`.
- The contraction/evaluation `tensorObj L Linv → O_X` is a LOCAL isomorphism: on `U` it is
  `O_U ⊗ O_U ≅ O_U`. Use the now-closed `tensorObj_restrict_iso` to commute `⊗` past `(-)|_U`, and
  `tensorObj_unit_iso` for `O ⊗ O ≅ O`.
- Glue: the local contraction isos agree on overlaps (naturality of `tensorObj_restrict_iso`), and
  "is-an-isomorphism" is a local property, so the global map is an iso ⇒ `tensorObj L Linv ≅ unit`.

Implementation hints:
- Mirror the cover/refinement bookkeeping of `tensorObj_isLocallyTrivial` (L1349): pick affine `W` per
  point via `exists_isAffineOpen_mem_and_subset`; refine trivialisations with `restrictIsoUnitOfLE`.
- For `Linv` itself: if no `Scheme.Modules`-level internal-hom/dual object exists in the project or
  Mathlib at the pinned commit, this is the INCOMPLETE-gate blocker — report it precisely (do NOT pin a
  helper-sorry). Possible alternative carriers to investigate before declaring absent: `SheafOfModules`
  internal hom / `sheafHom`, or constructing the dual as the sheafification of the presheaf dual.

### SECONDARY (bonus −1, do LAST) — re-route `tensorObj_assoc_iso` (L1152) + delete vestigial apparatus

- Replace the route-(d) whiskering proof body with the re-route onto `tensorObj_restrict_iso`
  (blueprint `lem:tensorobj_assoc_iso`, now the realized proof): over a common cover,
  `((M⊗N)⊗P)|_U ≅ (M|_U⊗N|_U)⊗P|_U ≅ M|_U⊗(N|_U⊗P|_U) ≅ (M⊗(N⊗P))|_U` — first/third arrows are
  `tensorObj_restrict_iso` (twice), middle is the canonical presheaf associator; glue via Hom-is-a-sheaf.
  (Hypotheses `hM hN hP` are retained to match the pin even if unused, as today.)
- THEN delete the now-dead apparatus (their blueprint `\lean{}` pins are already removed by writer ts218):
  `isLocallyInjective_whiskerLeft_of_W` (L600 — THE sorry, the −1), `W_whiskerLeft_of_W`,
  `W_whiskerRight_of_W`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`, `isLocallySurjective_whiskerLeft`,
  `toPresheaf_whiskerLeft_app_{tmul,apply}`, `isIso_sheafification_map_of_W`, `stalkLinearMap` (+ `_germ`,
  `_bijective_of_isIso`, `stalkLinearEquivOfIsIso`).
- Keep build GREEN. If any of those is still referenced (in this file or elsewhere), RETAIN it (now
  unpinned) and report which + why. Target: file sorry 3→2, project **80→79**.

### INCOMPLETE gate (re-affirmed by progress-critic ts218)
If `exists_tensorObj_inverse` bottoms out on a genuinely Mathlib-absent primitive, STOP and report the
EXACT blocker. Do NOT add it as a new helper-sorry and push the obligation forward (iter-214 d.1
anti-pattern). A precise blocker → mathlib-analogist round next iter.

### Ride-along cleanup (do if cheap; never at PRIMARY's cost)
- Fix 4 stale docstrings: module `## Status` block (L37–85, 15 iters stale); `tensorObj` (L987–991) and
  `tensorObj_functoriality` (L997–1007) falsely claim "typed sorry" bodies; `tensorObj_assoc_iso`
  docstring (L1115) "iter-212 status (typed sorry)" — now closed/re-routed.
- Drop `@[implicit_reducible]` on the sorry-body `addCommGroup_via_tensorObj` (L1414) until its body lands.
- Replace deprecated `Sheaf.val` → `ObjectProperty.obj` (17 sites) ONLY if mechanical and build stays green.

### Marker flags for review/sync (prover reports; does NOT edit blueprint)
- `lem:tensorobj_assoc_iso` proof → `\leanok`-eligible once the re-route lands (no sorry).
- `lem:tensorobj_inverse_invertible` proof → `\leanok`-eligible once closed.
- Deleted decls' standalone `\leanok` on `lem:isiso_sheafification_map_of_W` /
  `lem:islocallyinjective_whisker_of_W` → `sync_leanok` will remove once the Lean decls are gone.
