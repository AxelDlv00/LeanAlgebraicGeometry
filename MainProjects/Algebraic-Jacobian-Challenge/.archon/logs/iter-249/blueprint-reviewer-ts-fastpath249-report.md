# Blueprint Review Report

## Slug
ts-fastpath249

## Iteration
249

## Scope
Fast-path, scoped to `Picard_TensorObjSubstrate.tex` — specifically the §"The unit square (D2′):
a mate-calculus telescope" region (lines ~3382–3742). All five delta items reviewed against the
Lean source at `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:

  **Delta 1 — new linchpin `lem:sheafification_comp_pullback_eq_leftadjointuniq`** (lines 3624–3658)

  - Statement faithful: correctly asserts
    `sheafificationCompPullback φ = Adjunction.leftAdjointUniq A B`
    with A, B defined as the two composite adjunctions sharing the same right adjoint (sheaf
    pushforward preceded / followed by sheafification).
  - `\lean` pin `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq`
    verified against the Lean source: declaration exists at line 1575, proof is `rfl`, axiom-clean.
  - Proof sketch "holds by reflexivity" is faithful — the Lean proof IS `rfl`.
  - No `\uses{}` in statement block — appropriate; it is a definitional identity, not derived from
    other blueprint results.
  - No `\leanok` on statement block yet. This is correct: sync_leanok will tag it next run once it
    finds the axiom-clean Lean declaration. (Informational only — not a must-fix.)

  **Delta 2 — step-7 retype `lem:epsilon_presheaf_to_sheaf_unit`** (lines 3701–3742)

  - Retyped from ill-typed sheaf-level `Functor.LaxMonoidal.ε` form to `.val`-level
    (underlying-presheaf) reconciliation. Mathematically well-posed:
    — Both `ε(pushforward φ')` (presheaf lax unit) and `(unitToPushforwardObjUnit φ).val` are
      morphisms in the presheaf-of-modules category; their sectionwise equality is a legitimate
      and sufficient identity.
    — The statement explicitly disclaims sheaf-level lax-monoidal interpretation ("not a
      sheaf-level lax-monoidal-unit equation"), eliminating the prior ill-typedness.
  - The closing argument for (∗∗) is sound: after transposing the unit square across
    `pullbackPushforwardAdjunction φ` (Lean lines 1654–1661), the goal becomes a presheaf-level
    identity. The `.val`-level equality established by `lem:epsilon_presheaf_to_sheaf_unit` is
    exactly the sheaf-morphism equality (since morphisms of sheaves of modules ARE natural
    transformations of underlying presheaves).
  - `\uses{lem:presheaf_pushforward_laxmonoidal, lem:unitToPushforwardObjUnit_comp}` — both
    labels verified to exist (lines 2716, 3150). ✓
  - `\lean` pin `epsilonPresheafToSheafUnit` is NOT yet in the Lean file — this is expected and
    correct: it is precisely the (∗∗) sorry the prover is being dispatched to close.
  - No `\leanok` on statement block — correct (Lean declaration absent until prover closes it).

  **Delta 3 — `lem:leftadjointuniq_app_unit_eta` `\uses{}` update** (lines 3660–3699)

  - Statement `\uses{}` (line 3664) and proof `\uses{}` (line 3683) both now cite the linchpin
    `lem:sheafification_comp_pullback_eq_leftadjointuniq`. ✓
  - All cited labels exist: `lem:comp_homequiv_factor_sheafify_pullback` (line 3587),
    `lem:sheafification_comp_pullback_eq_leftadjointuniq` (line 3626). ✓
  - The proof narrative correctly uses the linchpin to justify the `rfl` rewrite at Lean
    line 1624 (`hg : ... = (A.leftAdjointUniq B).hom.app ...`). ✓

  **Delta 4 — assembly `lem:eta_bridge_unit_square` step-7 narrative** (lines 3575–3582)

  - Step-7 prose now says "at the (-).\mathrm{val} (underlying-presheaf) level" — consistent
    with retyped `lem:epsilon_presheaf_to_sheaf_unit`. ✓
  - The seven-step telescope chain is coherent:
    Steps 1–2: `Functor.map_comp` + `Adjunction.unit_naturality` (standard)
    Step 3: `lem:comp_homequiv_factor_sheafify_pullback` (closed, `\leanok`)
    Step 4: `lem:leftadjointuniq_app_unit_eta` (closed, `\leanok`)
    Step 5: `Adjunction.comp_unit_app` expansion (standard)
    Step 6: `lem:presheaf_unit_comp_map_eta` (closed, `\leanok`)
    Step 7: `lem:epsilon_presheaf_to_sheaf_unit` (the (∗∗) residual, sorry)
  - Assembly `\uses{}` (lines 3470–3484): all six named dependencies present and labelled. ✓
  - Statement block carries `\leanok` (line 3466) — correct, declaration exists in .lean at
    line 1641 (proof has the sorry, but the declaration skeleton is present). ✓

  **Delta 5 — `lem:pullback_tensor_iso_unit` proof `\uses{}` fix** (line 3348)

  - Proof `\uses{}` is now a single line:
    `\uses{lem:pullback_tensor_map, lem:isiso_pullbacktensormap_of_sheafifydelta,`
    `       lem:isiso_sheafifyeta_of_unitsquare, lem:eta_bridge_unit_square}`
  - No `\leanok` inside the `\uses{}` block. The former corruption (stray `\leanok` embedded in a
    multi-line `\uses{}`) is gone. ✓
  - All four cited labels verified to exist. ✓
  - Statement block carries `\leanok` on its own line (line 3331) — correctly placed OUTSIDE the
    `\uses{}` block. ✓

  **Cross-reference integrity in the D2′ region**

  - No broken `\uses{}` edges detected. Every label cited in `\uses{}` blocks in the edited region
    resolves to an existing `\label` in the file.
  - No `\leanok` / `\mathlibok` misplacements found (beyond the informational note above on the
    new linchpin's absent `\leanok`, which is correct pending sync_leanok).

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

One **informational** observation: `lem:sheafification_comp_pullback_eq_leftadjointuniq`'s
statement block has no `\leanok` yet. The corresponding Lean declaration exists and is axiom-clean
(`rfl` at line 1586). sync_leanok will tag it automatically next run. No action required.

---

## Overall verdict

`Picard_TensorObjSubstrate.tex` D2′ region: **complete + correct**, no must-fix finding.
The linchpin is a faithful statement of its `rfl` identity, step-7 is mathematically well-posed
at the `.val` level (no ill-typed sheaf-level `ε`), all `\uses{}` edges are valid, and the
former `\leanok`-in-`\uses{}` corruption is resolved. **HARD GATE CLEARS** — prover dispatch
on the (∗∗) sorry at `TensorObjSubstrate.lean:1672` is sanctioned this iter.
