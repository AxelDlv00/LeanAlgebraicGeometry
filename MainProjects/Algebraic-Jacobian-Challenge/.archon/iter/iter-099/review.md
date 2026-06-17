# Iter-099 (Archon canonical) / iter-101 (project narrative) — review

## Outcome at a glance

- **Single prover lane on `BasicOpenCech.lean`** to close
  `cechCofaceMap_pi_smul` per-summand `hG` discharge (was L768,
  now L811).
- **Result**: PARTIAL — 0 sorries closed; file compiles.
- **Structural advance**: YES — iter-101 plan's S1–S3 chain
  (Pi.smul_apply / show-pivot / 4-layer `← ConcreteCategory.comp_apply`)
  committed at L765–L779. The post-S3 goal is the deepest verified
  frame.
- **Sorry trajectory**: 6/6 in BasicOpenCech.lean (hard cap, no
  regression). Target of 5 missed. Total project sorries 14 → 14.
- **Line shift**: L768→L811 (+43 lines of iter-101 partial-chain
  tactics + S4–S6 escalation analysis comments); other sorries shift
  by the same offset (L860→L903, L1184→L1227, L1212→L1255,
  L1402→L1445, L1431→L1474).
- **Compile-verified**: yes (`lean_diagnostic_messages` returns `[]`
  for severity=error on whole file). Eighth consecutive compile-verified
  prover iteration.
- **No new axioms; no protected signatures touched.**
- **STREAK ESCALATION CRITERION TRIGGERED**: this is the **3rd
  consecutive substantive prover lane on this sorry without closure**
  (iter-099 + iter-100 + iter-101). Mandate for iter-100 (next):
  refactor lane.

## What the iter-101 plan got right

- **S1 (`simp only [Pi.smul_apply]`)** landed on first probe. Trivial
  pi-distribution as predicted.
- **S2 alternative** (`show` def-eq pivot) is the correct pattern in
  the post-funext frame: the plan's `rw [piIsoPi_hom_ker_subtype_apply]`
  fails (discrimination-tree mismatch through LinearEquiv coercion),
  but the prover correctly pivoted to `show` and got the same
  goal-shape change.
- **S3 (4-layer `← ConcreteCategory.comp_apply`)** lands cleanly,
  fusing `(Pi.π Z₂ j') ∘ eqToHom ∘ smul_thing ∘ e₁.symm` into one
  categorical composition. This is the cleanest possible frame for
  scalar extraction.

## What the iter-101 plan got wrong

- **S2 `rw [piIsoPi_hom_ker_subtype_apply Z₂ j']`** does NOT fire
  directly — the lemma's discrimination pattern keys on
  `(piIsoPi Z).hom.hom _ j`, but the goal has `e₂ x j'` where
  `e₂ = (piIsoPi Z).toLinearEquiv` (LinearEquiv coercion masks
  the head). Prover correctly substituted `show` def-eq pivot.
  **Lesson for next iter's plan**: verify `rw [lemma]` form fires
  in the target frame via `lean_multi_attempt` before transcribing;
  use `show` for def-eq pivots when LinearEquiv/Embedding coercions
  are in play.
- **E1 escape route (body-local rfl-helper)** assumed in iter-100
  AND iter-101 plans is now **CONFIRMED DEAD** — the helper
  `have h : (n • f).hom x = n • f.hom x := by intros; rfl` typechecks
  but `simp only [h]` / `rw [h]` report "no progress" because the
  discrimination tree pattern-match runs BEFORE rfl-evaluation. The
  body-local layer does NOT bypass the structural blocker on
  Pi.lift's anonymous closure.
- **In-place `set Pi_lift_thing : (∏ᶜ Z₁) ⟶ _ := Pi.lift _`**
  (in-place variant of E2) also fails — `_`-codomain ascription
  doesn't fold the actual `∏ᶜ (fun i_1 ↦ ...)` codomain in the goal.
  The top-level refactor variant (named per-coordinate `T : ∀ j,
  Z₁ (h j) ⟶ Z₂ j`) remains as the only durable escape.

## What iter-099 discovered (deep)

- **Discrimination-tree blocker is fully structural**: regardless of
  layer (`(n • f) ≫ g`, `(n • f).hom x`, `Pi.lift _ ≫ Pi.π _`,
  naming via `set`), Lean's discrimination tree fails when the
  smul's RHS or composition's LHS has a `Pi.lift fun i ↦ <body-with-i>`
  with i-referencing body. The failure is NOT about the lemma being
  missing — `ModuleCat.hom_zsmul` and `Preadditive.zsmul_comp` are
  both rfl-applicable in vacuum (verified iter-100); they simply
  cannot locate the occurrence syntactically.
- **`piIsoPi_hom_ker_subtype_apply` direction-of-application matters**:
  in iter-097 it fires in `← `-direction at the pre-funext frame
  (because the LHS has the raw `(piIsoPi).hom.hom _ j` shape); in
  iter-099 it fails in forward direction at the post-funext frame
  (because the LHS has the LinearEquiv-coerced `e₂ _ j'` shape).
  **The same lemma is NOT interchangeable across frames.**
- **`funext j'` per-coordinate pivot does NOT dissolve the
  discrimination tree class** when the morphism composition retains
  the anonymous-closure Pi.lift inside `ConcreteCategory.hom (_ ≫ _ ≫ _)`.
  Iter-100's hypothesis that this would unblock S4 is FALSE. Use
  `funext` for goal-shape simplification only; the structural
  blocker persists.

## What iter-100 (next) plan must do

1. **REFACTOR LANE MANDATE** — the streak criterion is triggered.
   Plan agent for iter-100 MUST schedule a refactor lane, NOT a
   prover-only lane against the L811 sorry. Slug recommendation:
   `pi-lift-thing-named-binder` or `cech-summand-via-named-T`.
2. **Directive shape** (verbatim sketch in
   `task_results/Cohomology_BasicOpenCech.lean.md` § "Recommended
   iter-102 escalation: option E2"): a top-level helper
   `cechCofaceMap_pi_smul_summand_via_named` with morphism family
   `T : ∀ j, Z₁ (h j) ⟶ Z₂ j` (named per-coordinate codomain),
   applied at the L811 site via `refine` with `T := fun j ↦
   (toModuleKPresheaf C).map (Pi.lift _).op` peeled into a binder.
   Same iter-098 split-slot precedent.
3. **Fallback** (if the refactor lane runs long or hits universe
   hygiene issues like iter-098 did): try the E3 `LinearMap.ext`
   route — `apply LinearMap.ext_iff.mpr; intro z; simp only
   [Pi.lift_apply]` to lift the goal to value level.
4. **DO NOT** prescribe a 4th raw-tactic pass against L811 in
   iter-100. The pattern-match blocker class is structurally
   immune to tactics at this point.
5. **Streak warning**: if iter-100's refactor lane lands AND the
   follow-up application closes L811, the streak breaks. If the
   refactor lane runs but the application doesn't close L811 in
   the same iter, that's 4 consecutive partial iterations on this
   sorry — at that point consider a bigger architectural rethink
   (replace the entire `cechCofaceMap_pi_smul` proof with a
   different structural approach).

## What's preserved byte-for-byte

- `alternating_sum_pi_smul_aux` body L478–L494 (iter-097/session 95).
- `alternating_sum_pi_smul_aux_sum_comp` L513–L537 (iter-098/session 96).
- `cechCofaceMap_pi_smul` prefix L539–L725 (iter-092 through iter-099
  bridge).
- Iter-098/session-96 bridge at L700–L712 (split-slot application).
- Iter-100/session-98 `funext j'` partial chain L726–L747.
- **NEW**: Iter-101/session-99 S1–S3 partial chain L765–L779
  (Pi.smul_apply + show + 4×← ConcreteCategory.comp_apply) +
  S4–S6 escalation analysis comments L780–L810.

## File state at iter-099 close

- Sorries: 6 in `BasicOpenCech.lean` (no change vs iter-098).
  Total project sorries: 14 (no change).
- Active sorry locations: L811, L903, L1227, L1255, L1445, L1474.
- Compile-verified; no new axioms.
- Iter-100 (next) target: REFACTOR LANE introducing named-T helper.

## Developer feedback channel (optional)

(none this iteration — the substantive observation is recorded in
the recommendations.md priority sections and the new dead-end
catalogue entries in PROJECT_STATUS.md Knowledge Base.)
