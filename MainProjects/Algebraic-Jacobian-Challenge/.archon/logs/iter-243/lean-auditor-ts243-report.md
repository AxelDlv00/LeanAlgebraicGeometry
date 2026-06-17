# Lean Audit Report

## Slug
ts243

## Iteration
243

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 3 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

**Notes:**

- **L43–45 (file header)**: The header still lists `isLocallyInjective_whiskerLeft_of_W` as a
  "remaining typed-`sorry` residual" alongside `exists_tensorObj_inverse` and
  `addCommGroup_via_tensorObj`. Per the iter-237 memory record, `isLocallyInjective_whiskerLeft_of_W`
  was closed axiom-clean at iter-237 (route-(d)), yet the header retains it as open. If that
  closure is genuine, the header overstates the sorry count for this file. This needs verification
  against `Vestigial.lean` (which reports "one open sorry"); if the Vestigial sorry is a DIFFERENT
  declaration (not `isLocallyInjective_whiskerLeft_of_W`), the header is stale.

- **L302–340 (`tensorObj_assoc_iso` docstring — "genuine residual is now the flatness")**: The
  docstring at L323–340 describes the old flatness-based route and asserts: "The genuine residual
  is now the flatness feeding steps 1 and 3: steps 1/3 need `J.W (toPresheaf (η ▷ P.val))` /
  `J.W (toPresheaf (M.val ◁ η))`, which `W_whiskerLeft/Right_of_flat` supply ONLY from the
  SECTIONWISE flatness instance…". The ACTUAL proof (L341–382) uses the flatness-free variants
  `PresheafOfModules.W_whiskerRight_of_W` / `W_whiskerLeft_of_W` and is UNCONDITIONAL — the body
  comment at L343–346 even says "UNCONDITIONAL (iter-238, step 0): the locally-trivial hypotheses
  are dropped". The stale docstring text directly contradicts the proof and would mislead a reader
  into thinking the associator still requires flatness hypotheses. The "UNCONDITIONAL" clarification
  lives only inside the proof block comment, not in the outer `/-- … -/` docstring.

- **L302–303 (`tensorObj_assoc_iso` docstring — "sorry-transitive" claim)**: The docstring says
  "it is `sorry`-transitive only through the route-(e) residual
  `isLocallyInjective_whiskerLeft_of_W`". If that declaration was closed axiom-clean at iter-237
  (as the memory claims), the sorry-transitivity claim is now wrong — the declaration would be
  fully axiom-clean. The docstring should either be updated to say "axiom-clean as of iter-238" or
  the Vestigial dependency should be re-verified.

- **L1254–1255 (`addCommGroup_via_tensorObj` docstring)**: References "iter-202 Lane TS scaffold"
  and "iter-204+ closure target". We are at iter-243; these iteration references are 39–41 iters
  old. Not an excuse-comment (the `sorry` is correctly labelled), but the stale iter tags create
  confusion about priority.

- **`pullbackValIso` (L1203–1210)**: No hidden sorry. The construction is genuine: it composes
  `(SheafOfModules.sheafificationCompPullback φ).app M.val).symm` (NatIso component, well-typed)
  with `(pullback f).mapIso (asIso (sheafificationAdjunction.counit).app M)` (counit at a sheaf is
  an iso, so `asIso` is valid). Type traces correctly: source `a_Y.obj ((pullback φ').obj M.val)`,
  target `(pullback f).obj M`. Docstring matches.

- **`pullbackTensorMap` (L1220–1236)**: No hidden sorry. The 4-step `refine` chain is
  mathematically coherent:
  1. `sheafificationCompPullback` moves pullback inside sheafification.
  2. `a_Y.map δ` applies sheafification to the presheaf-level oplax comparison (requires
     `presheafPullbackOplaxMonoidal φ'`, which in turn requires `presheafPushforwardLaxMonoidal φ'`
     and `(pushforward φ').IsRightAdjoint` — both synthesisable from Mathlib adjunction instances).
  3. `sheafifyTensorUnitIso` reconciles the extra sheafification layers.
  4. `a_Y.map (tensorHom (forget.map (pullbackValIso f M).hom) (forget.map (pullbackValIso f N).hom))`
     maps each factor back to the abstract pullback.
  Source and target at each step match; the final type is the declared one. The docstring honestly
  says "This is a *map only*: in general it is not asserted to be an isomorphism". ✓
  
  The `φ'` let-coercion (L1224–1225) is the correct fix for the CommRingCat/RingCat
  monoidal-instance disambiguation, as documented in the preceding commentary.

- **Phase-2 comment block (L1168–1194)**: Accurately documents what was delivered (the map `δ`)
  and what is Mathlib-absent (the concrete inverse-image model needed to upgrade `δ` to an iso).
  Not an excuse-comment; this is accurate mathematical documentation of a genuine Mathlib gap.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

**Notes:**

- **No `pushforwardBaseChangeMap_naturality` scaffolding**: Confirmed absent. No leftover commented-
  out tactic blocks from the removed brick. The file is clean.

- **`affineBaseChange_pushforward_iso` (L701–742)**: The body `sorry` is honestly documented.
  The partial proof does perform the genuine first reduction (`rw [Modules.isIso_iff_isIso_app_affineOpens]`
  at L709), and the block comment (L711–741) accurately lists the two Mathlib-absent obligations
  that remain: (1) the affine reduction's base-change-of-the-base-change-map compatibility and
  (2) the adjoint-mate ↔ `cancelBaseChange` identification. These are correctly described as each
  being a multi-hundred-LOC build. The theorem is NOT labelled as complete anywhere. ✓

- **`flatBaseChange_pushforward_isIso` (L751–764)**: The body `sorry` is honestly documented with
  a proof strategy comment naming the missing infrastructure (Čech complex for `SheafOfModules`).
  Not mislabeled as complete. ✓

- **All sorry-free declarations are genuine**: `globalSectionsIso_hom_comp_specMap_appTop`,
  `gammaPushforwardIso`, `gammaPushforwardTildeIso`, `gammaPushforwardIsoAt`,
  `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`,
  `IsLocalizedModule.powers_restrictScalars`, `tildeRestriction_isLocalizedModule`,
  `pushforward_spec_tilde_iso`, `gammaPushforwardNatIso`, `pullback_spec_tilde_iso`,
  and the locality criteria (`Modules.isIso_iff_isIso_stalkFunctor_map`,
  `Modules.isIso_of_isIso_app_of_isBasis`, `Modules.isIso_iff_isIso_app_affineOpens`)
  all have complete proofs with no sorries. Proofs are well-structured and use appropriate
  Mathlib infrastructure. ✓

- **`\leanok`-eligible check**: No declaration in this file looks like a placeholder masquerading
  as complete. The two sorry-bearing theorems are unambiguously marked incomplete. ✓

---

## Must-fix-this-iter

None.

---

## Major

- `TensorObjSubstrate.lean:323–340` — Stale flatness analysis in `tensorObj_assoc_iso` docstring.
  The text "The genuine residual is now the flatness feeding steps 1 and 3" and the entire
  `W_whiskerLeft/Right_of_flat` paragraph describe the OLD pre-iter-238 route. The actual proof
  is unconditional (uses `W_whiskerRight_of_W` / `W_whiskerLeft_of_W`, no flatness). A reader
  of the docstring gets a false impression that the associator still requires flatness or
  invertibility hypotheses. The clarification is buried in the body comment (L343), not the outer
  docstring. Should be excised or explicitly struck out from the public-facing docstring.

- `TensorObjSubstrate.lean:43–45 and 302–303` — File header and `tensorObj_assoc_iso` docstring
  both claim `isLocallyInjective_whiskerLeft_of_W` is a remaining sorry-residual. If it was
  closed axiom-clean at iter-237 (as the memory states), both claims are stale. Verify against
  `Vestigial.lean` and update whichever is wrong: either (a) update the header + docstring to
  remove the reference, or (b) confirm that Vestigial still has an open sorry attributed to that
  declaration and add a cross-file note explaining the state.

---

## Minor

- `TensorObjSubstrate.lean:1254–1255` — Stale iteration references ("iter-202 Lane TS scaffold",
  "iter-204+") in the `addCommGroup_via_tensorObj` docstring. At iter-243, these give a
  misleading impression about when this sorry was expected to close. Could be updated to simply
  note the current open status without the outdated iter references.

---

## Excuse-comments (always called out separately)

None found. Neither file contains excuse-comments of the "temporary wrong def", "placeholder",
or "will fix later" type. The two sorry-bearing theorems in `FlatBaseChange.lean` and the two
in `TensorObjSubstrate.lean` are each accompanied by accurate documentation of what is missing
and why — this is honest mathematical status reporting, not an admission that the code is wrong
while pretending it's right.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: Both files are clean with respect to the newly-added declarations (`pullbackValIso`
and `pullbackTensorMap` are genuine axiom-clean constructions, no hidden sorries); the two
acknowledged sorry-bearing theorems in `FlatBaseChange.lean` are honestly documented; no leftover
scaffolding from the abandoned `pushforwardBaseChangeMap_naturality` attempt. The only issues are
stale docstring text in `tensorObj_assoc_iso` (major) and a header/cross-file claim about the
`isLocallyInjective_whiskerLeft_of_W` sorry status that needs verification against `Vestigial.lean`
(major).
