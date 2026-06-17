# Recommendations for the next plan-agent iteration (iter-096)

## TL;DR

Iter-095 attempted the three plan-recommended routes (D′) `convert`,
(D″) `Finset.cons_induction`, and (D‴) `Preadditive.comp_sum` (the
prover relabelled them G/H/I) plus several minor variants. **All
failed against the same root obstruction**: the combination of (a)
nested-binding-depth references to the outer summation binder `i` in
the summand body, (b) inner `Pi.π (fun i ↦ ...)` shadowing the same
letter, and (c) the eqToHom-bridge between the named `∏ᶜ Z₂` and the
unfolded Pi-product carrier `ModuleCat.of k (∀ i, ↑(Z₂ i))` that is
def-equal but never syntactically equal.

The only iter-095 commit is a 4-line **cosmetic block at L589–L592**
that normalises `ModuleCat.Hom.hom` to `ConcreteCategory.hom` via an
abbrev-rfl. No structural advance. 6 sorries in `BasicOpenCech.lean`
unchanged; file compiles.

**The three syntactic routes are exhausted.** Iter-096 should NOT
retry them. Instead, **invoke the `refactor` subagent** to
reformulate `scK₀.f` coordinate-wise from the start so that no
`Pi.lift` / `Pi.π` / `eqToHom` appears in `cechCofaceMap_pi_smul`'s
goal at all.

## Stop retrying syntactic routes on `cechCofaceMap_pi_smul` L593

The iter-095 prover correctly diagnosed that the recipe in
`session_94/recommendations.md` was **circular**: every recipe step
that requires producing a `change` or `set`-fold target that
syntactically matches the goal contains, by construction, the HOU
blocker we are trying to break. Specifically:

- **Route (D′) `convert key₂ _ _ _`** requires `set F :=` to fold
  the summand first; `set` requires exact syntactic match; the
  match itself encodes the HOU obstruction. Iter-095 confirmed
  the `set F :=` body elaborates but does NOT fold the goal.
- **Route (D″) `Finset.cons_induction`** requires the summation
  carrier to be explicit; with the implicit `Finset.univ` and the
  binder-shadowed body, Lean's typeclass synthesis is stuck
  (`Fintype ?m.1151`).
- **Route (D‴) `Preadditive.comp_sum`** requires first fusing the
  outer `Pi.π Z₂ j` into the categorical composition via
  `← CategoryTheory.comp_apply` (or `← ConcreteCategory.comp_apply`,
  or `← LinearMap.comp_apply`, or `← ModuleCat.hom_comp`); ALL FIVE
  variants fail because the intermediate type between `Pi.π Z₂ j`
  and `(∑F) ≫ eqToHom` is def-equal but not syntactic. **This is
  precisely the iter-093 LinearMap-level `∘ₗ`-unfolding blocker
  surfacing one structural layer up at the outer composition.**

**Plan agent should explicitly enumerate these in `PROGRESS.md`'s
"Do not retry" section** alongside the iter-094 entries.

## Primary recommendation for iter-096: refactor subagent

The mathematical content of `cechCofaceMap_pi_smul` is that
`scK₀.f` is `R`-linear, where `scK₀.f` is the Čech alternating-sum
coface map. The current construction packages `scK₀.f` as a
`Pi.lift`-of-`Pi.π`-composition with an `eqToHom` bridge to align
the named Pi-product `∏ᶜ Z₂` with its unfolded carrier `ModuleCat.of
k (∀ j, ↑(Z₂ j))`. Every HOU obstacle iter-091 → iter-095 has hit
traces back to this packaging.

### Refactor directive (paste into `archon-refactor-agent.py --directive-file`)

```markdown
# Refactor: bypass Pi.lift/Pi.π/eqToHom in scK₀.f construction

## Goal

Reformulate `scK₀.f` (the Čech alternating-sum coface map used in
`cechCofaceMap_pi_smul`) coordinate-wise. In the new form, `scK₀.f.hom`
is constructed DIRECTLY as a `LinearMap`:

```lean
(scK₀.f.hom : (∀ i : Fin ((up ℕ).prev n + 1) → ↥s₀, ↑(Z₁ i)) →ₗ[k]
              (∀ j : Fin (n + 1) → ↥s₀, ↑(Z₂ j))) :=
  fun y j =>
    ∑ i : Fin (n + 1), (-1)^(↑i : ℤ) •
      ((toModuleKPresheaf C).map
         (Pi.lift fun x ↦ Pi.π (basicOpenCover ↑s₀ ∘ j)
                            ((SimplexCategory.Hom.toOrderHom
                              (SimplexCategory.δ i)) x)).op).hom
        (y (j ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))))
```

R-linearity then follows summand-wise from R-linearity of each
presheaf-restriction. No `Pi.lift ≫ eqToHom` appears in any goal
derived from `scK₀.f.hom`.

## Constraints

- Preserve `cechCofaceMap_pi_smul`'s top-level signature (it's the
  Mathlib-facing R-linearity fact). The reformulation is internal to
  the proof prefix.
- Preserve the iter-094 `rw [← ModuleCat.hom_comp]` breakthrough and
  the body-local `key₂` helper if they remain useful in the new form;
  otherwise mark them as removed.
- Insert `sorry` at any newly broken proof sites; do NOT fill the
  proofs. The prover will fill them in iter-097+.
- Keep the existing 6 transient `sorry` sites (L685, L1009, L1037,
  L1227, L1256, and the active L593) byte-for-byte unless the
  refactor specifically demands changing one of them.

## Out of scope

- Changing the public type or signature of `scK₀` itself, or
  changing `cechCochain` / `toModuleKSheaf` / `basicOpenCover` /
  `Z₁` / `Z₂` definitions.
- Adding new top-level axioms.
- Touching protected declarations.

## Deliverable

A new internal helper (e.g., `scK₀_f_coord` or
`cechCofaceMap_pi_smul_coord`) with the coordinate-wise reformulation,
plus an internal `iff` / `eq` lemma bridging the new form to the
existing `scK₀.f.hom`. The `cechCofaceMap_pi_smul` proof prefix should
then unfold the new form and discharge R-linearity per-summand. Trail
with `sorry` at the (smaller, single-summand) R-linearity site if
that remains open.
```

### Why this works

The new form's summand body
`((toModuleKPresheaf C).map ...op).hom (y (j ∘ δᵢ))`
has `i` only as the binder of the outer `Σᵢ`; `i` does NOT appear at
nested binding depths inside `Pi.lift`, and there is no `Pi.π
(fun i ↦ ...)` to shadow. The eqToHom bridge is also gone — the
output type `(∀ j, ↑(Z₂ j))` is the named target directly. R-linearity
then reduces to:

```
(r • y) j = Σᵢ (-1)^i (presheaf-restriction)((r • y) (j ∘ δᵢ))
         = Σᵢ (-1)^i (presheaf-restriction)(r • y (j ∘ δᵢ))
         = Σᵢ (-1)^i r • (presheaf-restriction)(y (j ∘ δᵢ))  ← per-summand R-linearity
         = r • Σᵢ (-1)^i (presheaf-restriction)(y (j ∘ δᵢ))
         = r • (f y) j
```

Each step is a single named lemma (`Pi.smul_apply` for step 1,
`map_smul` / `LinearMap.map_smul` for step 3, `Finset.smul_sum` for
step 4); none requires HOU pattern matching against a binder-shadowed
summand.

## Fallback if the refactor subagent declines or fails

If the refactor subagent reports the reformulation is infeasible
(e.g., because `scK₀.f` is built by a Mathlib categorical construction
we cannot bypass), the next-best option is:

**Generalisation lemma at the categorical level**: prove

```lean
have key₃ : ∀ (s : Finset (Fin (n+1)))
    (F : (i : Fin (n+1)) → i ∈ s → ((∏ᶜ Z₁ : ModuleCat k) ⟶ ∏ᶜ Z₂))
    (E : (∏ᶜ Z₂ : ModuleCat k) ⟶
         ModuleCat.of k ((i : Fin (n+1) → ↥s₀) → ↑(Z₂ i)))
    (z : ↑(∏ᶜ Z₁ : ModuleCat k)) (j : Fin (n+1) → ↥s₀),
    (Pi.π Z₂ j).hom ((∑ i ∈ s.attach, F i.1 i.2 ≫ E).hom z) =
    ∑ i ∈ s.attach, (Pi.π Z₂ j).hom ((F i.1 i.2 ≫ E).hom z)
```

with the proof going through `Finset.induction_on s` — this version
makes the Finset explicit (avoiding the iter-095 typeclass synthesis
failure on implicit `Finset.univ`), the family `F` takes membership
proof so the inner `i` is no longer a metavariable in the summand
body, and the outer `Pi.π Z₂ j` is bundled into the helper directly
so no later fusion step is needed. Application at the call site would
then be `rw [key₃]` followed by per-summand `Pi.lift_π_apply` collapse.

This fallback is also non-trivial (still needs `Finset.induction_on`
to navigate the eqToHom), but it does not require restructuring
`scK₀.f`. **Try the refactor first; this is the in-place backup.**

## Off-limits this iteration (carry to iter-096)

- `Differentials.lean` `cotangentExactSeq_structure case h_exact` —
  Route A/B decision pending; reactivate after BasicOpenCech lane
  closes.
- `Modules/Monoidal.lean` `instIsMonoidal_W` — Mathlib gap.
- `Jacobian.lean` `nonempty_jacobianWitness` — Phase C/E packaging,
  iter-100+.
- `Picard/Functor.lean` `representable` — gated on C0–C3.
- `BasicOpenCech.lean` `basicOpenCover_isCechAcyclicCover_*` substeps
  at L685 / L1009 / L1037 — gated on `cechCofaceMap_pi_smul` closing.
- `BasicOpenCech.lean` `g_R.map_smul'` (L1227), `h_loc_exact` (L1256)
  — gated on `cechCofaceMap_pi_smul` closing (Lane 1 cascade).

## Notes for the plan agent

1. **DO invoke the refactor subagent for iter-096.** This is the
   first time in the iter-091→iter-095 streak that no syntactic
   route remains untried. The structural HOU obstruction is genuine;
   the only escape is to remove the structures that cause it.

2. **Carry the iter-094 `rw [← ModuleCat.hom_comp]` breakthrough and
   the body-local `key₂` helper to the refactor input** as known-good
   prior art. They may or may not survive the refactor depending on
   whether the new `scK₀.f.hom` still has a `(∑F) ≫ eqToHom` shape
   internally. The refactor subagent should preserve them
   conditionally.

3. **Sorry hard cap for iter-096**: maintain 6 in `BasicOpenCech.lean`
   during the refactor (refactor agents insert `sorry` at broken
   proof sites). The cap can go to 7 transiently during the refactor
   if the new internal helper introduces one extra `sorry` site — but
   the refactor's task result must explicitly justify the bump and
   commit to closing back to 6 within iter-097.

4. **Four-iteration blocker-shift pattern**: iter-092 (foundation
   repair), iter-093 (per-application form), iter-094 (categorical
   re-folding via `← ModuleCat.hom_comp`), iter-095 (cosmetic ONLY,
   no structural advance). The streak of "−1 layer per iteration"
   has BROKEN this iteration. **Iter-095 is the first iteration in
   this streak with zero structural progress.** This is the signal
   that the syntactic strategy space is exhausted and structural
   refactor is required.

5. **`attempts_raw.jsonl` IS FRESH iter-095** (timestamps 09:45–10:07Z
   match the iter-095 prover window per `meta.json`). The harness
   pre-processor staleness from sessions 92/93/94 did NOT recur. Good
   signal for the developer fixes; no fresh debug-feedback note needed
   for that issue specifically this iteration.

6. **PROGRESS.md update needed**:
   - Mark `cechCofaceMap_pi_smul` step (c) syntactic strategy space
     as EXHAUSTED; transition the active blocker description from
     "categorical Preadditive distribution HOU" to "structural
     `Pi.lift`/`Pi.π`/eqToHom bridge requires coordinate-wise
     refactor".
   - Add iter-095 dead-ends to "Do not retry": `rw [← ConcreteCategory.comp_apply]`
     direct, `rw [show ... ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl]
     ; rw [← CategoryTheory.comp_apply]` ensemble, `conv_lhs => rw
     [← CategoryTheory.comp_apply]`, `set F := (-1)^↑i • Pi.lift ...`
     (set does not fold), `Finset.cons_induction` over implicit
     `Finset.univ` (typeclass synthesis stuck), `simp only [Pi.lift_π_apply]`
     against `Pi.π (Pi.lift ≫ ... ≫ eqToHom)`-shape goal.
   - Add the iter-095 cosmetic normalisation as a (preserved but
     no-op) marker in the "iter log" so future plan agents know the
     L592 line exists and can be relied on syntactically.

7. **`\notready` cleanup**: not applicable. No chapter blocks
   landed this iteration; no `\lean{...}` rename surfaced.
