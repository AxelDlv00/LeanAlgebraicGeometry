# Recommendations — after iter-271 (for the next plan iter)

## HIGH — closest-to-completion: the engine lane is DE-RISKED, prioritise it
The 5-iter kernel `whnf` wall on `pushPullMap_comp` (CechHigherDirectImage.lean) is **bypassed**
this iter. `pushPull_transport_cancel` (axiom-clean) + `erw` fire on the real goal without kernel
blow-up. The lane is now a well-scoped mechanical follow-up:
1. Add `lemma pushPullMap_comp_aux` (statement in `task_results/AlgebraicJacobian_Cohomology_CechHigherDirectImage.md`),
   close via `subst hg hk; simp only [eqToHom_refl, Category.comp_id]` → pure pseudofunctor pentagon →
   `pushPull_unit_mate kl gl₂` + `pseudofunctor_associativity (f:=kl,g:=gl₂,h:=p₁)` (4 `pullbackComp`
   cells match exactly).
2. Derive `pushPullMap_comp` from it via the `erw [pushPull_transport_cancel …]` skeleton.
3. Assemble `pushPullFunctor`, close `CechNerve`.
This is the single best ROI next pass — a 5-iter blocker turned into a documented ~60–100 LOC grind.
**Gotcha**: `rw [← Functor.map_comp]` fails *motive-not-type-correct* on the dependent `eqToHom(hkg)` —
use `conv`/`erw`.

## HIGH — blueprint coverage debt + dangling pin (plan-agent / blueprint-writer action)
Three blueprint-hygiene items the next plan iter must address before/while dispatching provers:
1. **Dangling pin** `lem:push_pull_functor` carries `\lean{AlgebraicGeometry.pushPullMap_comp}` but
   **no such declaration exists** (only an in-file comment). The block's `\leanok` (set by `sync_leanok`
   when `pushPullMap_id` became sorry-free) therefore over-states coverage. `% NOTE (iter-264)` has
   flagged this for **7 iters with no action**. Fix: split `lem:push_pull_functor` into two blocks
   (`pushPullMap_id` done; `pushPullMap_comp` pending), OR have the prover add a `lemma pushPullMap_comp
   … := sorry` stub so `sync_leanok` tracks it independently. (Both lean-vs-blueprint Cech + lean-auditor.)
2. **`pushPull_transport_cancel`** (new iter-271, axiom-clean infra) has **no `\lean{}` entry**. Add a
   brief lemma/remark block in `sec:cech_three_part` after the push-pull paragraph (suggested
   `\label{lem:push_pull_transport_cancel}`). 1-to-1 coverage debt.
3. **`sliceDualTransportInv`** (new iter-271 top-level def) has **no `\lean{}` entry**. Add an inline
   `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv}` inside the "Inverse." paragraph of
   `lem:slice_dual_transport` (Picard_TensorObjSubstrate.tex ~line 5922) — no new block needed.
Minor coverage debt also noted: `pushPull_unit_mate` (predates iter-271) has no pin.

## MEDIUM — D3′ tail (`sheafificationCompPullback_comp_tail`): 5th consecutive stall, treat as CHURNING
Sorry count on TensorObjSubstrate.lean has not moved (18→18) and this specific tail sorry has now
survived 5 iters of helper-adding. iter-271's advance is real but incremental: step (i) distribution
(1 closed tactic) + the `conjugateEquiv_whiskerRight` device (`hwr`) verified to elaborate (and the
analogist's `whiskerLeft` recipe corrected). **But `hwr` is currently dead scaffolding** — declared,
never consumed before the sorry (lean-auditor MAJOR, `TensorObjSubstrate.lean:2667`).
- **Do NOT assign another generic "add a helper" round.** The remaining work is a *single* structural
  step: transpose the whole tail through the `(h≫f)`-composite adjunction via `homEquiv.injective`
  using `leftAdjointCompNatTrans_assoc` (CompositionIso.lean:155), THEN `rw [hwr]` + `unit_conjugateEquiv`
  + `conjugateEquiv_comp`. The LHS-only re-transpose is **circular** (re-folds the R0-peel).
- If a focused prover pass on that transposition stalls again, escalate to a structural-refactor or
  mathlib-analogist consult on whether the tail's spelling should be pinned differently — not more
  helpers. The blueprint prose here is already adequate (lean-vs-blueprint TensorObj confirms), so the
  blocker is proof-engineering, not blueprint.
- Next prover should also **remove or consume the dead `hwr`** so the proof script doesn't accrete.

## MEDIUM — DUAL (`sliceDualTransportInv.app`): fresh, well-scoped ~20–40 LOC
The extraction landed and `invFun` is wired (`sliceDualTransport` internal holes 4→3). The app blocker
is now precisely pinpointed and is a *new* sub-build, not the old `≃ₗ`-packaging difficulty: the
codomain transport across the open-equality `he : f''ᵁf⁻¹ᵁW' = W'` lives in **distinct ModuleCat
fibers**, so a plain `eqToHom` cannot bridge it. Close via a `restrictScalars`-ε conjugation along
`X.presheaf.map (eqToHom (op he))` (same machinery `dualUnitRingSwapHom` uses for `f.appIso`), mirror
on the M-source leg. Then `naturality` (Subsingleton.elim + ε-naturality), then `sliceDualTransport`
`left_inv`/`right_inv` (`f.appIso` cancellation + `he`). One focused `prove` pass is warranted.

## LOW — comment/scaffolding hygiene (lean-auditor minors)
- `CechHigherDirectImage.lean:358` — `pushPull_transport_cancel` docstring says "via `rw`"; correct it
  to `erw` (companion comment at L299 is right).
- `CechHigherDirectImage.lean:36` — module docstring "six main declarations" undercounts (≥8 now).
- `TensorObjSubstrate.lean:43` — module header sorry-tracking attributed to "iter-262" (stale; count 3).
- `DualInverse.lean:39` — header says "4 remaining sorries"; actual is 5 (`sliceDualTransport` 3 +
  `sliceDualTransportInv` 2). Update to avoid an understated progress picture.
- `DualInverse.lean:309,310` — `exact sorry` → bare `sorry`.
- `DualInverse.lean:555` — `dual_restrict_iso` nests a `/- Planner strategy: -/` block inside the
  decl's doc region, making the docstring boundary ambiguous.

## Do-NOT-retry / dead ends (from this iter's task results)
- `pushPullMap_comp` via sectionwise `hom_ext; intro U` — exposes non-sectionwise adjunction units (dead).
- `simp`/`aesop_cat` on the post-subst pentagon — only reassociates, cannot apply the mate (dead).
- `rw` (not `erw`) of `pushPull_transport_cancel` — never fires (defeq-not-syntactic).
- D3′ tail LHS-only re-transpose — circular (re-folds R0-peel).
- DUAL: plain `eqToHom`/`subst hW'` to bridge the ModuleCat-fiber `he` gap — `W'` is a `set`-local; fails.

## Subagent reports (full detail)
- `task_results/lean-auditor-iter271-touched.md` — 0 must-fix, 2 major, 5 minor.
- `task_results/lean-vs-blueprint-checker-cech-iter271.md` — 2 major (dangling pin + coverage debt).
- `task_results/lean-vs-blueprint-checker-tensorobj-iter271.md` — 0 must-fix; blueprint adequate.
- `task_results/lean-vs-blueprint-checker-dualinverse-iter271.md` — 1 major (coverage debt).
