# Lean Audit Report

## Slug
iter001

## Iteration
001

## Scope
- files audited: 8 (all project .lean files under the project tree, excluding `.lake/` and `.archon/`)
- files with directive focus: 2 (`DualInverse.lean`, `TensorObjSubstrate.lean`)
- files audited at depth per directive: 2
- files audited at breadth (out-of-scope scan): 6

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 1 flagged
- **excuse-comments**: 0
- **notes**:
  - L388: `sliceDualTransportInv.naturality` — `exact sorry`. Clean tracked residual; body above is
    complete (app component axiom-clean, iter-303). No fake content. ✓
  - L525: `sliceDualTransport.toFun.naturality` — `· sorry`. Clean tracked residual; naturality of
    the leg-A∘leg-B family across W requires ε-naturality of `restrictScalars` not yet assembled.
    No fake content. ✓
  - L627, L629: `sliceDualTransport.left_inv` / `.right_inv` — `· sorry`. Clean tracked residuals,
    explicitly blocked on `invFun` + round-trip. No fake content. ✓
  - **L754-762** — **(MAJOR)** Two consecutive comments contradict each other: L754-757 says the
    isoMk naturality "cannot be discharged yet — it is left as the assembly residual"; L760-761
    then says "the connecting Hom-space is a subsingleton, so the square commutes definitionally."
    The `subsingleton` tactic at L762 closes the goal. One of the two comments is wrong:
    either L760-761 is correct (genuine thin-poset `Subsingleton` instance fires) and L754-757
    is stale, or `subsingleton` closes only due to sorry contamination in `sliceDualTransport.hom`
    and will fail when upstream sorries are filled. In neither case should both comments coexist.
    See Major section below.
  - L760-762: `subsingleton` close for the outer `isoMk` naturality. **(MINOR)** Thin-poset
    coherence motivation is plausible and consistent with `Subsingleton.elim _ _` used elsewhere
    in the file (L888, L891, L1097, L1107) — but those uses are on morphisms IN the thin poset
    (`Opens X` hom-sets), while L762 is on MODULE MAP equality. The mechanism is different. Needs
    verification that a genuine `Subsingleton` instance (not sorry-induced) fires.
  - L947: `set_option backward.isDefEq.respectTransparency false in` scoped to `homOfLocalCompat`.
    **(MINOR)** This option affects definitional equality during `isDefEq`. Scope is appropriately
    limited to the one declaration. No immediate harm, but unusual.
  - §0 (`unitDualSectionEquiv`, `dualUnitIsoGen`): Both complete, no sorries, naturality proved
    explicitly. ✓
  - `isIso_ε_restrictScalars_appIso` / `dualUnitRingSwap` / `dualUnitRingSwapInv` family: All
    clean, proofs use `isIso_ε_restrictScalars_appIso` correctly via `CategoryTheory.inv`. ✓
  - `sliceDualTransport.map_add'` (L531-539): Clean close via `Functor.map_add` + `Preadditive.add_comp`. ✓
  - `sliceDualTransport.map_smul'` (L561-593): Detailed explicit proof. The `conv_rhs; change`
    step at L580 works around a syntactic blocker documented in comments. The final step uses
    `Scheme.Hom.appIso_inv_naturality`. Looks correct. ✓
  - `sliceDualTransport.invFun` (L615-624): Wired to `sliceDualTransportInv` with a correct
    `hβ` discharge via `Iso.hom_inv_id` of the structure ring iso. ✓
  - §B (`presheafDualUnitIso`, `dual_unit_iso`): Clean, axiom-clean by construction. ✓
  - `dual_isLocallyTrivial` (L838-847): Proof body correct — three-step chain assembled. Inherits
    `dual_restrict_iso` sorry transitively (expected). ✓
  - **§C restored tail (L861-1194)**: All four declarations (`homLocalSection`, `topSectionToHom`,
    `topSectionToHom_app`, `homOfLocalCompat`) are complete with no `sorry`. The
    `homLocalSection.naturality` proof (L872-910) is explicit and correct — thin-poset
    `Subsingleton.elim` used only for morphisms IN `Opens X` (hom-sets), not for module maps.
    `homOfLocalCompat` linearity (L1070-1188) is long but well-structured, axiom-clean. ✓

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- **outdated comments**: 0 flagged (long iter-history STATUS-NOTEs excluded per directive)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L712: `exists_tensorObj_inverse` — `sorry`. Clean tracked residual; full strategic setup above
    the sorry is substantive. No fake body. ✓
  - L2623: `sheafificationCompPullback_comp` — `sorry`. Sits after meaningful adjunction expansion
    (`apply … injective`, `rw [sheafificationCompPullback_eq_leftAdjointUniq]`,
    `erw [Adjunction.homEquiv_leftAdjointUniq_hom_app]`, `simp only [Adjunction.comp_unit_app]`).
    The documented obstacle (composite-adjunction-unit cocycle assembly) is genuine. No fake body. ✓
  - L2851: `pullbackTensorMap_restrict` — `sorry`. Follows `simp only`, `rw`, `simp only` steps
    that do real work. The documented 4-square composition paste route is described accurately. ✓
  - No excuse-comments in proof bodies or declarations.

---

### AlgebraicJacobian.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**: 7-line import file only. No concerns.

---

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L220: In the `pullbackAlongProjection` docstring (iter-187 history block): "`IsLocallyTrivial.pullback`
    (Stacks 01HH, named typed sorry pending the affine chart chase)." **(MINOR)** Stale — the
    referenced declaration at L156-193 has a complete 38-line proof (seven iso-chain steps).
    The docstring's historical note should be updated to reflect closure.
  - `IsLocallyTrivial.pullback` (L156-193): Complete proof, correct seven-step iso chain using
    `restrictFunctorIsoPullback`, `pullbackComp`, `pullbackCongr`, and `asIso (… pullbackObjUnitToUnit …)`.
    The `CategoryTheory.final_of_representablyFlat` instance used at L173 is standard. ✓
  - Remaining declarations: All clean or trivially defined (no live sorries in code). ✓

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File correctly declares zero file-local sorries (confirmed by grep). Upstream sorry
    propagation from `exists_tensorObj_inverse` is accurately documented. ✓

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
- **outdated comments**: 0 flagged (not deeply audited)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**: Zero sorry mentions. Out-of-scope breadth scan only. No concerns.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean
- **outdated comments**: 0 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**: Zero sorry mentions. Out-of-scope breadth scan only. No concerns.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L15-16: File header says "`FlatWhisker` / `WhiskerOfW` (route-(e) flatness-free whiskering;
    one open sorry `isLocallyInjective_whiskerLeft_of_W`)". **(MAJOR)** This is false. The
    declaration `isLocallyInjective_whiskerLeft_of_W` at L352-446 has a complete proof (no sorry).
    `TensorObjSubstrate.lean` L71-73 confirms it was "CLOSED iter-237". The header claim
    actively misleads readers into thinking there is an open sorry where there is none.
  - `isLocallyInjective_whiskerLeft_of_W` (L352-446): Proof complete, no sorry. The stalkwise
    argument (tensor–stalk commutation via `stalkTensorIso`, stalkwise iso of `g` via
    `isIso_stalkFunctor_map_of_W`, induction on `TensorProduct.induction_on`) is correct. ✓
  - `W_whiskerLeft_of_W` (L453+): Depends on `isLocallyInjective_whiskerLeft_of_W`; clean. ✓

---

## Must-fix-this-iter

None. No declaration meets the must-fix bar:
- No excuse-comments (no admission of wrong/placeholder definitions).
- No weakened-wrong definitions.
- No parallel-API constructs.
- No suspect bodies on substantive claims (all sorries are clean placeholder sorries at known residuals, with no fake structure imposed before them).
- No unauthorized axioms.

---

## Major

- `DualInverse.lean:754-757` — Comment block says the isoMk naturality square "cannot be
  discharged yet — it is left as the assembly residual, per the planner bar," but L760-762
  immediately closes it with `subsingleton`. The two comments are contradictory. Either (a) the
  L754-757 block is stale and should be removed/corrected (the thin-poset `subsingleton` close is
  genuine and stable), or (b) the `subsingleton` close works only due to sorry contamination in
  `sliceDualTransport.hom` and will break when the upstream sorries are filled — making this a
  hidden pending proof obligation. The comment contradiction is the concrete auditable signal; the
  resolution determines whether a real naturality proof is needed at this site.

- `Vestigial.lean:15-16` — File header incorrectly claims "`isLocallyInjective_whiskerLeft_of_W`"
  has "one open sorry." The declaration at L352-446 is fully proved. `TensorObjSubstrate.lean`
  L71-73 corroborates: "CLOSED iter-237." The stale header misleads any reviewer scanning the file
  for open obligations.

---

## Minor

- `DualInverse.lean:760-762` — The `subsingleton` tactic closes the outer `isoMk` naturality
  square of `dual_restrict_iso`. The "thin-poset coherence" justification is described in the
  comment but uses a different mechanism than the explicit `Subsingleton.elim _ _` pattern used
  for morphisms IN the thin poset elsewhere in the file (L888, L891, L1097, L1107). Those uses
  are for equalities in `Opens X` hom-sets; L762 is for module map equality. The relevant
  `Subsingleton` instance (if genuine) deserves a code comment that names it, or an explicit
  `exact Subsingleton.elim _ _` in place of the opaque `subsingleton` tactic. This makes
  verification easier when upstream sorries are filled.

- `DualInverse.lean:947` — `set_option backward.isDefEq.respectTransparency false in` applied
  globally to `homOfLocalCompat`. Scope is appropriately limited to the `in` block but the
  option's effect on definitional equality checking is non-obvious. A short comment explaining
  why the option is necessary would help future readers.

- `LineBundlePullback.lean:220` — Docstring for `pullbackAlongProjection` refers to
  `IsLocallyTrivial.pullback` as "a named typed sorry pending the affine chart chase." The
  declaration is fully proved (L156-193). A stale historical note from iter-187.

---

## Excuse-comments (always called out separately)

None. No declaration in any project source file carries an excuse-comment of the form "temporary
wrong def", "placeholder", "will fix later", "wrong but works", or similar.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 3
- **excuse-comments**: 0 (also counted under must-fix-this-iter above; separate section for visibility)

Overall verdict: The two in-scope files are structurally sound — all 7 known tracked sorries have
clean bodies with no fake structure, the §C restored tail is complete and axiom-clean, and no
excuse-comments or weakened-wrong definitions are present. The two major findings are stale comments
(one in DualInverse.lean with a self-contradictory comment around the `subsingleton` close, one in
Vestigial.lean incorrectly claiming an open sorry). Neither blocks current prover work.
