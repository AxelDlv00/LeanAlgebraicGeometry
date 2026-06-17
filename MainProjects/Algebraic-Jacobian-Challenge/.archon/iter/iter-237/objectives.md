# Iter-237 objectives — detail

## Lane 1 — `Picard/TensorObjSubstrate/Vestigial.lean` [mathlib-build] — CRITICAL PATH

**Goal:** close the single `sorry` (line 299) `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`
— the associator's sole open obligation — now that the d.2 iso `stalkTensorIso` is built axiom-clean
(iter-236). Closing it makes `tensorObj_assoc_iso` (TensorObjSubstrate.lean) sorry-free → the by-hand
`CommGroup` `thm:pic_commgroup`.

Blueprint: `chapters/Picard_TensorObjSubstrate.tex`, lemma
`lem:islocallyinjective_whiskerleft_via_stalk` (`\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}`),
with two new supporting lemma blocks added this iter:
- `lem:W_implies_stalkwise_iso` (`\lean{PresheafOfModules.isIso_stalkFunctor_map_of_W}`) — the d.1-bridge.
- `lem:stalk_tensor_commutation_naturality_right` (`\lean{PresheafOfModules.stalkTensorIso_naturality_right}`) — B-naturality.

**Two ingredients to build (mathlib-build, axiom-clean, go as far as possible):**

1. **d.1-bridge** — `J.W g → ∀ x, IsIso ((stalkFunctor Ab x).map ((toPresheaf).map g))` on the
   topological site `Opens X`. Mathlib pieces (verified to exist this iter):
   - `CategoryTheory.GrothendieckTopology.W.isLocallyInjective` (J.W → locally injective).
   - `TopCat.Presheaf.app_injective_iff_stalkFunctor_map_injective` (sheaf: app injective ⟺ stalk injective).
   - `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` (sheaf morphism iso ⟺ iso on all stalks).
   - the locally-surjective-on-stalks characterisation.
   The general-site decl is UNPROTECTED; the prover may specialise to `Opens X` (where stalks exist).
   Its consumers `W_whiskerLeft_of_W` / `W_whiskerRight_of_W` and ultimately `tensorObj_assoc_iso`
   already instantiate at `R := X.presheaf` (TensorObjSubstrate.lean:372/375) — keep those call sites
   working. If a cross-file signature ripple is unavoidable, hand off the consumer-repoint as a
   refactor note (do NOT break TensorObjSubstrate.lean — a different file's lane).

2. **B-naturality of `stalkTensorIso`** (the genuinely new helper): for `g : M → N`, under
   `stalkTensorIso` the stalk of `A ◁ g` is `LinearMap.lTensor A_x (stalkLinearMap g x)`, i.e.
   `stalkTensorIso A N ∘ (id_A ⊗ g)_x = lTensor A_x g_x ∘ stalkTensorIso A M`. Prove on germ
   generators `germ(a) ⊗ germ(m)` via `stalkTensorLinearMap_germ_tmul` / `stalkTensorRev_germ_tmul`
   + `stalkLinearMap_germ`, then `TensorProduct.induction_on`.

**Conclude:** d.1-bridge ⇒ each `g_x` iso ⇒ `stalkLinearEquivOfIsIso g x` (already built);
`LinearEquiv.lTensor A_x (g_x)` is an iso (flatness-free); B-naturality identifies `(A◁g)_x` with it,
so `(A◁g)_x` iso for all x ⇒ `A◁g ∈ J.W` (d.1-bridge reverse) ⇒ `GrothendieckTopology.W.isLocallyInjective`.

**Constraint (progress-critic ts237 CONVERGING):** keep `StalkTensor.lean` untouched (d.2 done/correct);
the unit is d.1-bridge + B-naturality + the conclusion. No further sub-helper fragmentation of d.2.
STRUCTURAL: do NOT import `Vestigial`'s dead apparatus beyond what's needed; preserve acyclicity.

## Lane 2 — `Cohomology/FlatBaseChange.lean` [mathlib-build] — ENGINE (HARD sorry-closure commitment)

**Goal (progress-critic ts237 WATCH / STRICT-STUCK):** close `affineBaseChange_pushforward_iso` this
iter, via building the brick `pushforward_spec_tilde_iso` first. A zero-sorry-closure round re-triggers
STUCK with no further UNCLEAR reprieve.

Blueprint: `chapters/Cohomology_FlatBaseChange.tex`, `lem:pushforward_spec_tilde_iso` (rewritten this
iter to the non-circular route-iii) + the 3 Γ-fragment pins.

**Build `AlgebraicGeometry.pushforward_spec_tilde_iso`** via route (iii) (non-circular):
- Comparison morphism `α : (restr φ M)~ → (Spec φ)_* M~` as tilde-adjoint of `gammaPushforwardTildeIso`.
- Reduce to basic opens `D(a)` via in-file `Modules.isIso_of_isIso_app_of_isBasis` (basic opens basis).
- On `D(a)`: source = `(restr φ M)[1/a]` over `R[1/a]`; target = `M[1/φa]` (since `(Spec φ)⁻¹ D(a) = D(φa)`)
  over `R[1/a]` by restriction; agree because `a` acts through `φa` (`IsLocalizedModule` compat) ⇒ iso on
  each `D(a)` ⇒ iso. QC of the pushforward follows AFTER (tilde modules QC, closed under iso) — never before.
- **Then close `affineBaseChange_pushforward_iso`** via the full-faithfulness reframe
  (`isIso_fromTildeΓ_iff` + reflect-isos ⇒ `IsIso α ↔ IsIso (moduleSpecΓFunctor.map α)`) + `cancelBaseChange`.
  The object iso also discharges QC-of-pushforward for free.

**Do NOT attempt** the deep `flatBaseChange_pushforward_isIso` (Čech + flatness) — documented sorry.
mathlib-build: no sorry pins; commit axiom-clean fragments + decomposition if not fully closed.

## Reversing signals (for iter-238 planning)
- Lane 1: if the B-naturality balloons or the d.1-bridge specialisation forces a cross-file refactor
  that the prover can't complete, iter-238 dispatches a `refactor` subagent to specialise the whisker
  chain to `Opens X` across Vestigial + TensorObjSubstrate, then re-dispatch the prover. The carrier
  pivot + d.2 route stay; only the wiring tactic would be reconsidered.
- Lane 2: if `affineBaseChange_pushforward_iso` is NOT closed, progress-critic STUCK re-fires. Corrective
  (autonomous, not user-escalation per the standing directive): typed-sorry-pin the brick is FORBIDDEN
  (mathlib-build); instead deprioritize the FlatBaseChange affine lane and re-route the engine seed to a
  different ungated A.2.c-engine sub-lane (e.g. a Mayer–Vietoris / relative-Proj brick), OR consult the
  mathlib-analogist on the `IsLocalizedModule`-on-basic-opens identification if that is the specific wall.
