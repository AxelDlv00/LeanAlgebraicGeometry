# Blueprint Writer Directive

## Slug
differentials-iter121

## Target chapter
blueprint/src/chapters/Differentials.tex

## Strategy context

Iter-121 launches milestone M1 (per `STRATEGY.md`): the bridge
between the section module of `relativeDifferentialsPresheaf f` at
an affine `V ⊆ X` and the appLE-algebra Kähler module `Ω[B/A]`,
where `A := Γ(S, U)`, `B := Γ(X, V)`, `V ≤ f ⁻¹ᵁ U`. The bridge
factors into sub-steps M1.a (the submonoid `M := {g ∈ A :
appLE(g) ∈ B^×}`), M1.b (the cofinality + `IsLocalization`
statement), M1.c (the Kähler module of a localization is zero),
M1.d (the tower-cancellation iso for K\"ahler differentials), and
M1.e (assembly of the bridge).

The `blueprint-reviewer-iter121` report (must-fix-this-iter)
identified two correctness defects already fixed inline by the plan
agent (`\end{remark>` typo, three broken
`\ref{sec:bridge-out-of-scope}` refs), plus FOUR substantive defects
in the new M1 section that you (the writer) are dispatched to fix.

## Required content

You revise the **existing** section `\sec{Bridge: presheaf form ↔
algebra-Kähler form on an affine chart (milestone M1)}` (anchor
`\label{sec:bridge}`) and the associated lemmas to address the
following four issues:

### Required item 1: M1.b cofinality proof skeleton

The current proof of `lem:appLE_isLocalization` (around lines
160–163 of the post-fix file) reads "Mathlib leverage:
`AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` ... plus a
cofinality-of-directed-colimit lemma that may need to be supplied
as part of M1.b" — but supplies no proof skeleton for the
cofinality step. The blueprint-reviewer flags this as the explicit
"heart of the milestone" with no proof skeleton.

**Replace this prose with a concrete proof skeleton.** Provide the
following decomposition:

1. **Step 1 — Cofinality of basic opens.** The directed system of
   opens `{W : f V ⊆ W ⊆ U}` (where `V ⊆ X` and `U ⊆ S` are affine
   opens, `V ≤ f ⁻¹ᵁ U`) admits as a cofinal subfamily the family
   of basic opens `{D(g) ⊆ U : g ∈ A, f V ⊆ D(g)}`, equivalently
   `{D(g) : g ∈ M}` for `M := {g ∈ A : appLE(g) ∈ B^×}`.

   *Why cofinal*: every open of an affine scheme `U = Spec A` is a
   union of basic opens (`Mathlib.AlgebraicGeometry.Spec`,
   `PrimeSpectrum.isBasis_basic_opens` or the `Opens.exists_finset_inf_le_basicOpen`
   approach); for any `W` with `f V ⊆ W ⊆ U`, the open `W` is a
   union of basic opens `D(g_i)`; the topological cover `f V ⊆ W =
   ⋃ D(g_i)` quasi-compact + Noetherian-or-cover argument lets us
   pick a single `D(g)` with `f V ⊆ D(g) ⊆ W` (if `f V` is
   quasi-compact, which it is as the image of `V ⊆ X` quasi-compact
   under `f` is contained in the union of finitely many basic opens
   among the `D(g_i)`; their product `g = ∏ g_i` has
   `D(g) = ⋂ D(g_i)` contained in each `D(g_i)`, hence in `W`).

   *The key bridge identity*: `f V ⊆ D(g)` if and only if `g`
   becomes a unit in `B = Γ(X, V)` after pulling back. This is by
   `Scheme.preimage_basicOpen_eq_basicOpen` together with
   "`V ⊆ X.basicOpen h` iff `h` is a unit in `Γ(X, V)`" (Mathlib
   `Scheme.basicOpen_eq_of_isUnit` or
   `IsAffineOpen.basicOpen_eq_iff_isUnit`).

2. **Step 2 — Localizations and directed colimits.** For each
   `g ∈ M`, the basic-open section ring is the localization
   `O_S(D(g)) = A_g` (Mathlib `[verified]`:
   `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` gives
   `IsLocalization.Away g (Γ(S, X.basicOpen g))`, i.e. localization
   of `A` at the single element `g`).

3. **Step 3 — Colimit-of-localizations is localization-at-product.**
   The directed colimit
   `colim_{g ∈ M} A_g` of single-element localizations indexed by
   the (filtered) submonoid `M` is the localization
   `Localization M` of `A` at the multiplicative set `M`. This is
   the classical "localization at a multiplicative set is the
   directed colimit of localizations at finitely-generated
   sub-monoids" identity. Mathlib leverage:
   - `IsLocalization.Away` for the individual `A_g`;
   - `Localization.equivLocalizationMonoidIsoMk` or `IsLocalization.map`
     for the universal property characterisation;
   - the directed-colimit-of-rings construction
     `Mathlib.RingTheory.Localization.AtPrime` (or the more general
     `Mathlib.RingTheory.Localization.Submonoid`) — the writer
     should check Mathlib `b80f227` for the exact name of "colimit
     of single-element localizations under inclusion of generated
     submonoids equals the localization at the full submonoid"; if
     missing, flag as a Mathlib gap to be filled by M1.b.

4. **Step 4 — Identify the directed colimit with `A_colim`.** The
   project's `A_colim := (f^{-1}_{psh} O_S)(V) = colim_{W : f V ⊆ W
   ⊆ S} O_S(W)` is the colimit over the directed system from Step
   1. By cofinality (Step 1) plus Step 2 + 3, this colimit equals
   `Localization M A`, i.e. `IsLocalization M A_colim` holds (via
   the canonical algebra map `A → A_colim`).

**Note explicitly which Mathlib pieces are gaps**: the cofinality
lemma "colimit over a cofinal subsystem equals colimit over the
full system" exists in Mathlib for general `CategoryTheory.Functor.Final`
(`Mathlib.CategoryTheory.Limits.Final`); the application to
`TopCat.Presheaf.pullback` may need a wrapper. Name the candidate
Mathlib home for the wrapper: `Mathlib.AlgebraicGeometry.Presheaf.InverseImage`
or `Mathlib.AlgebraicGeometry.Morphisms.Cofinality`.

### Required item 2: M2.a cross-chapter reference (informational only — actual M2.a expansion is in Jacobian.tex)

In `lem:appLE_isLocalization`'s proof skeleton, briefly note: "The
same cofinality argument has a parallel in M2.a's
`Hom(ℙ¹_k, A) = A(k)` rigidity argument (Jacobian.tex § C.2), where
the bridge between the algebraic-side `Spec` and the
scheme-side `ℙ¹` proceeds via a similar localization-cofinality
unfold." (One sentence is sufficient; do not expand M2.a here —
that's a separate chapter.)

### Required item 3: Fix the `\uses{...}` direction on `lem:kaehler_localization_subsingleton`

The current `\uses{lem:appLE_isLocalization}` in
`lem:kaehler_localization_subsingleton`'s declaration is
mathematically backwards: "Kähler module of a localization is
zero" is a generic algebraic fact, logically independent of
the project-specific `appLE_isLocalization`. Replace with:

```
  \uses{}
```

(empty `\uses{...}`, since the lemma genuinely depends on no
chapter-local label).

The `\uses{lem:appLE_isLocalization}` already correctly appears on
`thm:relativeDifferentialsPresheaf_iso_kaehler_appLE`, which IS the
right dependency direction.

### Required item 4: Clean up "out-of-autonomous-loop scope" language

Section `\sec{Converse direction --- out of autonomous-loop scope}`
(label `sec:converse-out-of-scope`) and the tail section
`\sec{Content out of autonomous-loop scope}` still use the
deprecated "out of autonomous-loop scope" framing four times. Per
the iter-121 STRATEGY.md pivot, this language is replaced:

- The converse direction is now M4 (optional future milestone,
  driven by downstream consumer demand). Update the
  `\sec{Converse direction}` section header to drop the
  out-of-scope suffix; the body remains correct as a documented
  counterexample. Add one paragraph at the start of the section
  saying: "This direction is recorded as an optional future
  milestone M4 (see `STRATEGY.md`). Closure requires the
  deformation-theoretic hypothesis `Subsingleton (Algebra.H1Cotangent
  A B)`, which the project may wire up if a downstream consumer
  demands the iff form."
- The "Content out of autonomous-loop scope" tail section (sheaf
  condition, cotangent exact sequence, cotangent space at a
  section, Serre-duality genus identity) is honestly disclosing
  iter-117 trims that are now M5+ on the implicit roadmap. Update
  the section title to `\sec{Content scheduled for later milestones}`
  and add a leading paragraph: "Each bullet below is a future
  milestone whose Mathlib infrastructure is not yet available;
  inclusion in this list does NOT mean the project has abandoned
  it. The roadmap progression is: M1 (this iter) → M2 / M3
  (existence routes) → M4 (converse) → M5+ (sheafification,
  cotangent exact sequence, etc.)."

## Out of scope

- **Do NOT touch any other blueprint chapter.** The M2.a rigidity
  sub-step in `Jacobian.tex § C.2` is the subject of a separate
  blueprint-writer dispatch this iter (slug `jacobian-c2-iter121`,
  dispatched in parallel by the plan agent). Do not edit
  `Jacobian.tex` from here.
- **Do NOT touch `.lean` files.** The bridge declaration is added
  by a separate refactor subagent.
- **Do NOT add `\leanok` markers.** The `sync_leanok` phase handles
  those.
- **Do NOT expand M1.c, M1.d, or M1.e beyond their current proof
  sketches.** The M1.b cofinality proof skeleton is the only
  proof-content addition this writer pass.

## References

- `references/challenge.lean` — the project's authoritative protected
  signatures; informs the `\lean{...}` hints but does NOT need to
  be re-read for this writer pass (the bridge is non-protected new
  material).
- Stacks Project Tag 02M5 — "Cofinal subsystems of basic opens of
  an affine open under restriction to an affine subset" — is the
  mathematical analogue of the cofinality argument; the writer may
  cite this as a Stacks reference in the proof skeleton.
- Hartshorne II.5 — basic-open generation of opens in affines.

## Expected outcome

After the writer's edits, `Differentials.tex` is `complete: true`
and `correct: true` on a re-audit:

- M1.b's cofinality proof skeleton is concrete (Steps 1–4 with
  named Mathlib pieces).
- `lem:kaehler_localization_subsingleton`'s `\uses{...}` direction
  is correct (empty).
- The "out-of-autonomous-loop scope" framing is replaced with M4 /
  later-milestone language per the iter-121 pivot.
- The chapter is on the active prover route for iter-122 (M1.a or
  M1.b prover lane).
