# Iter-251 objectives — detail & recipes

Two parallel prover lanes (M=2), both A.1.c.sub, both feeding `RelPicFunctor.addCommGroup`.
Blueprint chapter for BOTH: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
(consolidated; `% archon:covers` now lists `TensorObjSubstrate.lean`, `StalkTensor.lean`,
`Vestigial.lean`, `DualInverse.lean`). HARD GATE cleared for every target by blueprint-reviewer
br251 (0 must-fix).

---

## Lane TS-cmp — `Picard/TensorObjSubstrate.lean` [prove] — CRITICAL PATH

Author + prove, **in this order** (D3′ depends on D1′; D4′ on both):

### D1′ — `pullbackTensorMap_natural` (`lem:pullback_tensor_map_natural`) — FRONTIER, expected easy
δ-naturality of the sheaf-level comparison map. Mathlib `Functor.OplaxMonoidal.δ_natural`
(+ whiskered `δ_natural_left`/`_right`, and the trailing-`≫` reassociated
`δ_natural_assoc`/`_left_assoc`/`_right_assoc`) pasted with the sheafification-naturality
squares. `\uses{lem:pullback_tensor_map, lem:presheaf_pullback_oplaxmonoidal}` (both closed).
2-step. If this does NOT close, the "idioms transfer" assumption is wrong → flag for re-decompose.

### D3′ — `pullbackTensorMap_restrict` (`lem:pullback_tensor_map_basechange`) — the sole genuinely-new mate calculus
δ commutes with the open-immersion base-change square. **ARMED** — read `analogies/d3-251.md`
IN FULL before attempting. Headline (mathlib-analogist d3-251, ALIGN_WITH_MATHLIB):

- **Mirror the PROVEN `pullbackObjUnitToUnit_comp` (L859), swapping `_η`→`_δ`.** Work at the
  **PRESHEAF level** (where Mathlib's genuine oplax `δ` lives, ~L1212), THEN transport through the
  three sheafification bridges of `pullbackTensorMap`. Do NOT build a parallel δ-composition API;
  do NOT apply `comp_δ` to the sheaf-level `pullbackTensorMap` directly.
- Named lemmas (verified signatures in `analogies/d3-251.md`):
  `Functor.OplaxMonoidal.comp_δ` (δ of a composite = `G.map (δ F) ≫ δ G`);
  `Adjunction.leftAdjointOplaxMonoidal_δ` (δ = `(adj.homEquiv).symm ((unit⊗unit) ≫ μ G)`);
  `δ_natural_*`; `comp_μ`; mate API `CategoryTheory.conjugateEquiv`/`mateEquiv`/
  `unit_conjugateEquiv`; `Scheme.Modules.conjugateEquiv_pullbackComp_inv` (sheaf level);
  `PresheafOfModules.pullbackComp`/`pushforwardComp`; `Scheme.Modules.pullbackCongr` (the
  `f∘j' = j∘g` device — see `restrictIsoUnitOfLE` L396 for the unit analog).
- **ASYMMETRY to budget:** Mathlib gives the SHEAF `conjugateEquiv_pullbackComp_inv` but only
  PRESHEAF δ and NO presheaf conjugate identity (`PresheafOfModules.conjugateEquiv_pullbackComp_inv`
  loogle → empty). So D3′ must re-derive the conjugate-pullbackComp identity at the presheaf level
  (small supplement from `unit_conjugateEquiv` + `conjugateEquiv`); it cannot reuse the sheaf one for
  the δ part.
- **`.val`-friction kit (iter-250 KB, transfers — same `a_Y` recurs at L1209):**
  `restrictScalarsId_map` (L1650, `:= rfl`) stripped by **syntactic `rw`**;
  `erw [Category.assoc, ← Functor.map_comp, …]` keyed-defeq merge when plain `rw [Category.assoc]`
  silently fails to match on `PresheafOfModules`-over-`Sheaf.val` composites; reassociate with
  `rw [δ_natural_*_assoc]` or the hand idiom `(Category.assoc _ _ _).symm.trans (h ▸ Category.id_comp _)`.
  **CONFIRMED DEAD END (do NOT repeat):** `show`-into-syntactic-category to strip `restrictScalars (𝟙)`
  over sheafification → catastrophic `whnf` (>6.4M heartbeats). Use the propositional `:= rfl` strip.
- No one-shot "δ commutes with restriction along a strong-monoidal functor" lemma exists — the
  mechanism IS `comp_δ` (strong-monoidal `G` ⇒ `δ G` iso). PROCEED, no shortcut.

### D4′ — `pullbackTensorIsoOfLocallyTrivial` (`lem:pullback_tensor_iso_loctriv`) — chart-chase assembly
Only if D3′ closes. 4-step: (D3′) restrict to `f⁻¹Uᵢ` via base-change coherence; (D1′) transport
trivialisation through naturality; (D2′, CLOSED) unit-pair iso; assemble globally via
`lem:isiso_of_isiso_restrict`. Structurally mirrors the proven `tensorObj_preserves_locally_trivial`
/ `IsLocallyTrivial_pullback`. Then `IsInvertible.pullback`.

**Bar:** close D1′ at minimum; attempt D3′ with the armed kit and leave real compiling partial state
+ a one-line handoff naming the EXACT residual subgoal + which idiom was tried if it resists. NEVER an
opaque re-reduction. D4′ is the stretch goal.

**Secondary cleanup (only if time; comment-only, deferred-OK):** lean-auditor ts250 flagged a stale
D2′ handoff comment ~L1452–1476 and the fragile `set_option backward.isDefEq.respectTransparency false`
on `epsilonPresheafToSheafUnit` (axiom-clean; a polish-pass concern, not this iter's bar).

**Guardrails:** do NOT touch `exists_tensorObj_inverse` (~L683 — it stays a sorry this iter, closes
in a future iter once the dual chain lands). Do NOT revive the general Lan build (D1, off path).

---

## Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean` [prove] — INDEPENDENT parallel lane

The file already exists (scaffolded iter-251) with three sorry stubs carrying detailed
`/- Planner strategy: -/` blocks. Author the proofs **bottom-up**:

### `homOfLocalCompat` (`lem:sheafofmodules_hom_of_local_compat`) — FRONTIER base (all deps closed)
Compatible local `𝒪_X`-module morphisms over an open cover glue to a unique global morphism.
2-step: (i) glue the underlying ab-sheaf morphism via `TopCat.Presheaf.IsSheaf.hom` +
`existsUnique_gluing`, converting each `f i` to a local section through `Vestigial.overSliceSheafEquiv`;
(ii) promote to `𝒪_X`-linear via `Scheme.Modules.homMk`. **Most fragile piece: the `s i` naturality
field** — build it (and its `Subsingleton.elim`-on-thin-poset naturality) as a standalone lemma FIRST.
Full recipe in the in-file stub comment.

### `dual_restrict_iso` (`lem:dual_restrict_iso`) — the C-bridge, GENUINE NEW BUILD
Restriction along an open immersion commutes with the sheaf-level dual. Mirrors `tensorObj_restrict_iso`
Steps 1–4 with `dual` for `⊗`: Step1 `restrictFunctorIsoPullback`; Step2 `sheafificationCompPullback`;
Step3 strip outer sheafification; Step4 (new) close the residual PRESHEAF goal
`pushforward β (PresheafOfModules.dual M.val) ≅ PresheafOfModules.dual ((pushforward β).obj M.val)`
sectionwise via `InternalHom.restrictScalarsRingIsoDualEquiv` (closed). **WARM-CONTEXT WARNING
(progress-critic pc251):** Step 4 is NOT covered by `overSliceSheafEquiv` (different categories: sheaf
vs presheaf; fixed value-cat vs varying ring `𝒪_Y(V)`; finer slicing). If the sectionwise ring-iso
build resists after a genuine attempt, do NOT thrash — leave compiling partial state and flag for a
targeted mathlib-analogist consult on "dual of pushforward along a ring iso" (next-iter corrective).
See iter-230 C-wiring diagnostic (TensorObjSubstrate.lean ~L613–656) + the in-file stub comment.

### `dual_isLocallyTrivial` (`lem:dual_isLocallyTrivial`) — needs `dual_restrict_iso`
3-step chain: `dual_restrict_iso U.ι L` → `dualIsoOfIso eL` (contravariant) → `dual_unit_iso` (dual of
the unit is the unit, derivable from `InternalHom.internalHomEval` + presheaf left unitor — a small
inline sub-lemma, NOT blocked). Pattern identical to `tensorObj_isLocallyTrivial` (L526). Full recipe
in-file.

**Bar:** close `homOfLocalCompat` (frontier base) at minimum; attempt `dual_restrict_iso` with the
warm-context warning honored. If `homOfLocalCompat` (deps all closed) does NOT close, the dual chapter
is thinner than br251 judged → writer pass before re-dispatch (reversing signal).

**Guardrails:** stay in `DualInverse.lean`; do NOT touch `TensorObjSubstrate.lean` (the other lane owns
it). `exists_tensorObj_inverse` is NOT closed this iter (it lives in `TensorObjSubstrate.lean`; closes
once the chain lands + a future consolidation refactor moves it down).

---

## Reversing signals (armed)
- D1′ does not close → arming/transfer assumption wrong → re-decompose D1′.
- `homOfLocalCompat` does not close (all deps closed) → dual chapter thinner than judged → writer pass.
- D3′ reproduces the `.val`-friction PARTIAL×2+ despite the armed kit → escalate to a structural
  rethink of the D3′ proof shape (NOT a 7th cosmetic retry), per the iter-250 armed-pivot posture.
