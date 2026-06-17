# Recommendations for iter-250

## TOP PRIORITY — the armed BINARY signal FIRED; do NOT re-dispatch an identical prove pass

The iter-249 plan armed an explicit, binary reversing signal: *"if this prove pass does NOT close
L1672, iter-250 runs a **mathlib-analogist** consult — NOT another helper round, NOT a third
fine-grained decomposition. The diagnostic is binary: did L1672 close? — not did the residual
shrink?"* **L1672/L1741 did NOT close.** So the signal fired and iter-250 must honor the armed
corrective, not repeat the same dispatch.

Concretely, iter-250 should:

1. **Run the armed `mathlib-analogist` (api-alignment) consult** on `SheafOfModules.pushforward`'s
   action on morphisms (substep (i): is `R_X.map ((pushforward φ).map g) = (pushforward φ').map g.val`
   the definitional/API-correct form?) and on the presheaf↔sheaf `ε` reconciliation (substep (iii)).
   This is the named corrective; record its verdict before any prove dispatch.
2. **Author the one genuinely-open math item: `epsilonPresheafToSheafUnit`** (the SOLE open
   mathematical content per the lean-vs-blueprint checker). Sectionwise goal:
   `ε(pushforward φ') = (unitToPushforwardObjUnit φ).val`, both sides acting as `φ.hom.app X`
   sectionwise; `unitToPushforwardObjUnit_val_app_apply` is the value lemma to drive it. The
   blueprint block `lem:epsilon_presheaf_to_sheaf_unit` already specifies this precisely.
3. **Then a focused `prove`/fine-grained pass on the 3 concrete substeps only** (i)/(ii)/(iii),
   assembling into the L1741 `sorry`. Use the documented friction idiom (below). Do **NOT** re-touch
   the abstract telescope (steps 1–6) — it is closed and verified; do NOT add more abstract helper
   lemmas (that is the churn pattern the armed signal forbids).

If iter-250 *also* fails to close L1741 after the analogist consult + a concrete pass, that is a
true STUCK escalation requiring a structural rethink (or genuine user escalation) — not a 6th pass.

## Reusable proof pattern discovered (carry into the prover directive)

- **`Category.assoc` friction on `PresheafOfModules`-over-`Sheaf.val` composites.** `rw [Category.assoc]`,
  `rw [← Category.assoc]`, `reassoc_of% h`, and direct `rw [h]` all *silently fail to match*
  `(f ≫ g) ≫ h` on these composites (instance/defeq friction). The **working idiom** (used for
  `hrhs`/`hXtri` this iter) is:
  `(Category.assoc _ _ _).symm.trans (h ▸ Category.id_comp _)`.
  Also: `(forget ⋙ restrictScalars).map` must be split via `simp only [Functor.comp_map]` first, and
  helper lemmas must be stated in the SAME split form as the goal after that `simp only`. And
  `rw [hrhs]` on a `homEquiv`-object defeq fails — use `refine Eq.trans ?_ hrhs.symm` instead.
  **Apply this idiom directly to the Y-side triangle (substep (ii)) to avoid re-discovering it.**

## Plan-agent follow-ups (from lean-vs-blueprint checker — MAJOR, but not prover blockers)

- **Pin `isIso_of_isIso_restrict`** (the B-connector) with a `\lean{...}` statement block in
  `Picard_TensorObjSubstrate.tex` — the chapter references it by name in prose but has no Lean pin.
- **Pin `pullbackObjUnitToUnit_comp`** — it is `\uses{}`-referenced in the chapter but lacks a
  `\lean{...}` statement block.
- These are statement-only blueprint additions (no proof obligation); both decls already exist and
  are axiom-clean.

## Cosmetic / low-priority (from lean-auditor — all MINOR, no action gates anything)

- Module-status docstring line anchors are stale: `exists_tensorObj_inverse` "~L692"→actually L699;
  `pullbackEtaUnitSquare` residual "~L1717"→actually L1741. A prover touching the file can refresh.
- The cross-module `internalHomEval` status note (L60–64) and the inline "NOTE for next iter"
  project-log (L1737–39) belong in `task_results/`, not source comments.
- Add `-- OFF-PATH` on the `pullbackLanDecomposition` `def` (currently only flagged in section prose).
- Add an explicit "(to be built)" on the `epsilonPresheafToSheafUnit` reference at L1735.

## Do NOT re-assign (blocked / guardrailed)

- **`exists_tensorObj_inverse` (L699)** — the deferred ⊗-inverse lane. Out of scope until the
  D2′→D3′→D4′ chain and `RPF.addCommGroup` close. Needs two bridges (C: `dual_isLocallyTrivial`;
  A: SheafOfModules morphism descent). Honestly documented in-body; leave guardrailed.
- **`pullbackTensorMap_unit_isIso` (L1747)** — has no own sorry; closes for free once
  `pullbackEtaUnitSquare` closes. Do not attempt directly.
- **The abstract telescope (steps 1–6 of `pullbackEtaUnitSquare`)** — CLOSED and twice-verified.
  Do not re-decompose or add helper lemmas around it.

## `sync_leanok` observation (deterministic phase — NOT a review action)

`sync_leanok` removed 23 / added 1 `\leanok` in the TS chapter this iter. Two effects are mixed:
(a) correct removal of taint from the ~D2′-dependent decls that transitively rest on the open (∗∗)
sorry; (b) per the lean-vs-blueprint checker, the proof blocks of 4 *standalone-closed* lemmas
(`compHomEquivFactor`, `leftAdjointUniqUnitEta`, `presheafUnit_comp_map_eta`,
`sheafificationCompPullback_eq_leftAdjointUniq`) currently lack proof `\leanok` and should gain it
on the next sync. The plan agent should confirm sync correctly re-marks (b) once L1741 closes; this
is sync's domain (the file builds clean — not laundering, not a regression).
