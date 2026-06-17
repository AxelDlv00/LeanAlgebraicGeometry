# blueprint-writer directive — refresh `lem:tile_section_localization` Step 4/5 (remove the dead approach)

## Chapter to edit

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this chapter), the proof of
`lem:tile_section_localization` — currently lines ~4860–4931 (Steps 1–5).

## Why

The iter-045 prover proved every mathematical ingredient axiom-clean but the assembly was blocked on
three **Lean-engineering** walls (W1–W3). A mathlib-analogist consult (iter-046,
`analogies/tile-descent-instance-shape.md`) found the root cause and the fix: the walls came from the
**Step-4 prose's Lean-implementation recipe**, which says to "install a \(\Gamma_R(-,\mathcal F)\)
module structure together with the scalar tower on the common underlying section type, by transport
along the carrier identity." That dynamic-instance-installation recipe is the anti-pattern that fails
(installing a `Spec`-noncomputable module instance in a proof body). The correct, Mathlib-idiomatic
route makes both ring actions **structural** by viewing the tile section through the standard
**restriction-of-scalars** object — no dynamic install. Mathematically this is just the base-ring
descent of the localisation; the misleading part is purely the implementation prose.

## What to change

1. **Rewrite Step 4** so it is a clean MATHEMATICAL statement and removes the dead implementation recipe:
   - State Step 4 as: *the section-restriction map of Step 2 is, after restriction of scalars from
     \(R_g\) to \(R\), the section-restriction map \(\Gamma_R(D(g),\mathcal F)\to\Gamma_R(D(gf),\mathcal F)\)*.
     The identification of the two underlying maps is the carrier identity
     (Lemma~\ref{lem:restrict_obj_mathlib}) read as an equality of \(R\)-linear maps; the scalar-tower
     compatibility \(R\to R_g\) needed to make this restriction-of-scalars meaningful is supplied at
     the source open \(V=\top\) by Lemma~\ref{lem:tile_scalar_compat} and at the target open
     \(V=D(\bar f)\) by Lemma~\ref{lem:tile_scalar_compat'} (now FORMALISED — drop the "mechanical reuse,
     not new mathematics / required" framing; cite `tile_scalar_compat'` as the done general-\(V\) companion).
   - **Remove** the sentences prescribing "install … a module structure together with the scalar tower
     … by transport along the carrier identity" and any "underlying-type level, not the bundled module
     objects" implementation detail. Keep the mathematically-true observation that the tile sections and
     \(\mathcal F\)-sections carry different base rings (\(R_g\) vs \(R\)) — but frame the resolution as
     "the descent is the restriction of scalars along \(R\to R_g\)", NOT as "install instances on a
     common underlying type". No Lean tactics, no instance names, no `letI` — the blueprint is
     mathematical intent.
2. **Step 5** stays (base-ring descent via
   `isLocalizedModule_powers_restrictScalars_of_algebraMap`); make sure its prose reads as the formal
   restriction of scalars applied to the Step-4 map, consistent with the rewritten Step 4.
3. **Update / remove the stale review NOTEs** at lines ~4898–4901 (they ask the planner to author the
   `tile_scalar_compat'` block and refresh the paragraph — both now done) so they no longer describe the
   analogue as "to author / required". Keep the `% NOTE (review iter-045)` recording the decl was
   absent/blocked only if still accurate; you may add a one-line `% NOTE` that the iter-045 W1–W3 walls
   were diagnosed as a manual-instance-installation anti-pattern resolved by the restriction-of-scalars
   carrier (mathematical-level note only).
4. Do NOT touch the `\uses{}` list, the `\lean{}` pin, or any `\leanok`/`\mathlibok` marker. Do NOT touch
   `lem:tile_section_comparison` (stays unformalised). Keep all changes inside the
   `lem:tile_section_localization` proof block.

## Out of scope

The five general-\(V\) companion blocks were authored this iter by a separate writer — do not duplicate
them. Do not edit any other lemma block.
