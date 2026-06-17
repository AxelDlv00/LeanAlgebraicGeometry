# AlgebraicJacobian/RiemannRoch/RRFormula.lean

## Iter-185 Lane H — outcome: **PARTIAL** (2 → 1 sorries, build GREEN)

### Sorry tally

* Entering: **2 sorries** (file did NOT build — see below).
* Exiting: **1 sorry** (named typed-sorry helper).
* Net decrement: **−1**.

Per directive acceptable-outcome (ii) **PARTIAL**: a single Tier-3 helper
closed Tier-1 axiom-clean, plus one named typed-sorry helper added
(helper budget 1 of 2 used).

### Pre-existing build failure on file (fixed L353/L373)

`lean_diagnostic_messages` reported `failed_dependencies` but
`lake build AlgebraicJacobian.RiemannRoch.RRFormula` failed with
**two unsolved-`congr 1` errors** inside
`Scheme.eulerCharacteristic_sheafOf_single_add` (the `+ve` and `−ve`
inductive-step `key`/`h1` bridges).

The `congr 1` tactic was reducing the goal to an unsolved
`WeilDivisor.sheafOf a = (b).sheafOf` where `a = b` was provided by the
in-scope `hsplit` hypothesis, but `congr` was not applying `hsplit`.
Replaced both bridges with `congrArg (fun e => χ(sheafOf e)) hsplit`,
which closes them axiom-clean.

Without this fix Lane H could not even produce a clean build, so the
two Tier-3 helpers could not have been verified.

## `Scheme.finrank_H0_toModuleKSheaf_eq_one` (L231)

### Attempt 1
- **Approach:** Build the H⁰-bridge `LinearEquiv` chain via the existing
  project infrastructure in
  `Cohomology/StructureSheafModuleK/Carriers.lean`:
  - `HModule_zero_linearEquiv` — Ext₀ ≃ Hom-from-constant-sheaf;
  - `constantSheafGammaHom_linearEquiv` — constant-sheaf-Γ adjunction;
  - `homFromOne_linearEquiv` — Hom-from-`k` evaluation at `1`;
  - `SheafGammaObj_linearEquiv_top` — `Sheaf.Γ` reads the top section.

  Compose into a single `LinearEquiv`, transport `Module.finrank` via
  `LinearEquiv.finrank_eq`, then close the resulting
  `finrank kbar (C.left.presheaf.obj (op ⊤)) = 1` with:
  - `module_finite_globalSections_of_isProper` (Stein, iter-044) gives
    `Module.Finite kbar Γ(C, O_C)`;
  - `IsIntegral.component_integral` gives `IsDomain Γ(C, O_C)` (the
    `[Nonempty ↥↑⊤]` side-condition is discharged from
    `IsIntegral.nonempty` via `Set.mem_univ`);
  - `Algebra.IsIntegral.of_finite` (auto-instance) bridges
    `Module.Finite` to `Algebra.IsIntegral`;
  - `IsAlgClosed.algebraMap_bijective_of_isIntegral` then gives the
    bijective algebra map, and
    `Module.finrank_of_bijective_algebraMap` yields `finrank = 1`.
- **Result:** **RESOLVED (Tier-1 axiom-clean).** `lean_verify` reports
  `axioms: [propext, Classical.choice, Quot.sound]` — kernel only.
- **Coercion gotcha (1h dev time, documented inline):** The
  `[Nonempty ↥↑U]` instance argument of `IsIntegral.component_integral`
  uses sort coercion `↥` (CoeSort) where `haveI`-registered instances
  with the term coercion `↑↑` failed to unify with the synthesis target
  `↥↑⊤`. Bypassed via `@`-form direct application supplying the
  `Nonempty` arg by position with `⟨⟨hNECurve.some, Set.mem_univ _⟩⟩`.
- **Ready for marker:** `\leanok` (proof block — body sorry-free,
  axiom-clean).

## `Scheme.eulerCharacteristic_sheafOf_succ` (L258)

### Attempt 1
- **Approach:** Factor into a substantive single named typed-sorry helper
  `Scheme.eulerCharacteristic_of_shortExact_skyscraper` that packages
  three Hartshorne IV.1.3 inputs together (χ-additivity on a SES,
  iso-invariance of χ, χ-of-skyscraper = 1). The consumer
  `eulerCharacteristic_sheafOf_succ` then assembles sorry-free:
  1. Obtain `S, hSE, hX1, hX2, h13` from
     `Scheme.WeilDivisor.sheafOf_ses_single_add` (Lane K typed sorry).
  2. Apply
     `eulerCharacteristic_of_shortExact_skyscraper C S hSE Y h13`
     to get `χ(S.X₂) = χ(S.X₁) + 1`.
  3. Rewrite `S.X₁`, `S.X₂` back to `sheafOf` via `hX1`/`hX2`.
- **Result:** **PARTIAL (assembly Tier-1 axiom-clean assembly modulo the
  one named typed sorry).** The consumer body itself has zero `sorry`;
  the only remaining `sorry` in the file is the body of the named
  Tier-3 helper.
- **`lean_verify` on consumer:** axioms include `sorryAx` (transitive
  via the named helper). On the helper itself: also `sorryAx`. On
  upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus` and
  `l_eq_degree_plus_one_of_genus_zero`: `sorryAx` (transitively).
- **Decidable side-condition (resolved):** `skyscraperSheaf P.point` in
  the helper signature requires `[∀ U, Decidable (P.point ∈ U)]`. Added
  as a class hypothesis on the helper; the consumer discharges it via
  the `classical` tactic.

## `Scheme.eulerCharacteristic_of_shortExact_skyscraper` (NEW HELPER L329)

The single typed-sorry helper introduced this iter. Substantive type:
given any SES `0 → F → G → H → 0` of `ModuleCat kbar`-valued sheaves on
the curve `C` plus a witness `Nonempty (H ≅ skyscraperSheaf P.point k̄)`,
we conclude `χ(G) = χ(F) + 1`.

The body assembly (for iter-186+) requires:

1. **`Abelian.Ext.covariantSequence`** (Mathlib, present at b80f227 in
   `Algebra/Homology/DerivedCategory/Ext/ExactSequences.lean`) supplies
   the 5-term exact `Ext(X, S.X_i)` sequence for any SES `S` in any
   abelian category. Specialise `X = (constantSheaf).obj (ModuleCat.of
   k̄ k̄)` to recover the LES
   `H⁰(F) → H⁰(G) → H⁰(H) → H¹(F) → H¹(G) → H¹(H) → H²(F) → ...`.
2. **Grothendieck vanishing**: `H^i(C, ·) = 0` for `i ≥ 2` on a
   one-dimensional scheme. Mathlib has `Sheaf.H` of an `AddCommGrp`-valued
   sheaf but no Grothendieck vanishing theorem for schemes. Likely
   project-side work needed (multi-iteration sub-build).
3. **Finite-rank alternating sum identity** along the truncated exact
   sequence: if the LES becomes 6-term (with `H²` columns zero), the
   alternating sum of `finrank`s along the LES is `0`, giving
   χ-additivity.
4. **Iso-invariance of χ**: `H ≅ k(P)` lifts through
   `Abelian.Ext.linearEquiv₀` to a `finrank` equality on each `HModule`.
5. **χ(skyscraperSheaf P k̄) = 1**: needs `H⁰(C, k(P)) ≅ k̄` (stalk at
   P) and `H¹(C, k(P)) = 0` (skyscraper cohomology vanishes above
   degree 0). Mathlib likely has skyscraper-stalk identifications, but
   the H>0 vanishing on the project's `HModule` carrier is project work.

This is a multi-iteration project; the helper is sized as a "Tier-3
honest typed sorry" per blueprint vocabulary.

### Lemmas/infrastructure found (relevant for iter-186+)

- `IsAlgClosed.algebraMap_bijective_of_isIntegral` (Mathlib) — used to
  close H⁰-bridge.
- `Module.finrank_of_bijective_algebraMap` (Mathlib) — used to close
  H⁰-bridge.
- `IsIntegral.component_integral` (Mathlib) — used to close H⁰-bridge.
- `Algebra.IsIntegral.of_finite` (Mathlib instance) — bridges
  `Module.Finite` to `Algebra.IsIntegral`.
- `Abelian.Ext.covariantSequence`,
  `Abelian.Ext.covariant_sequence_exact₁`/`₃'` (Mathlib) — the LES of a
  SES of sheaves, ready for χ-additivity at iter-186+.

### Negative search results

- No `CategoryTheory.ShortExact.eulerChar_additive` in Mathlib at
  b80f227 (confirmed gap, per blueprint chapter §4 note).
- No `HomologicalComplex.eulerChar_of_shortExact` (only
  `HomologicalComplex.eulerChar` exists; no SES additivity API).
- No scheme-level Grothendieck vanishing
  (`H^i(X, F) = 0 for i > dim X`) in Mathlib at b80f227.

## Blueprint marker recommendation

- `def:eulerChar_curve`: already has `\leanok` (body concrete since
  iter-174).
- `def:l_invariant`: already has `\leanok` (body concrete since
  iter-174).
- `thm:euler_char_eq_deg_plus_one_minus_genus`: keep `\leanok` (proof
  body sorry-free assembly; transitive `sorryAx` via named helper +
  `sheafOf` typed sorry from RR.3).
- `thm:riemannRoch_genus_zero`: keep `\leanok` (proof body sorry-free
  assembly).

(`\leanok` is managed by the deterministic `sync_leanok` phase, not by
this agent.)

## Build & axiom audit

- `lake build AlgebraicJacobian.RiemannRoch.RRFormula`: **GREEN** (1
  `sorry` warning at L329, no errors).
- `lake build` (full project): **GREEN**.
- `lean_verify` on the four pinned declarations of this chapter:
  - `Scheme.eulerCharacteristic` — no axioms beyond Mathlib.
  - `Scheme.WeilDivisor.l` — no axioms beyond Mathlib.
  - `Scheme.finrank_H0_toModuleKSheaf_eq_one` (helper, this iter) —
    **axiom-clean (no `sorryAx`)**.
  - `Scheme.eulerCharacteristic_sheafOf_succ` — `sorryAx` via named
    helper.
  - `Scheme.eulerCharacteristic_sheafOf_zero` — `sorryAx` via RR.3
    `sheafOf_zero` typed sorry + H⁰ bridge typed sorry (latter now
    discharged).
  - `Scheme.eulerCharacteristic_sheafOf_single_add` — `sorryAx` via
    `_succ` helper.
  - `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus` —
    `sorryAx` (transitively).
  - `Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero` —
    `sorryAx` (transitively).
- Zero-axiom-build retention: **preserved** (no new project axioms
  introduced).
