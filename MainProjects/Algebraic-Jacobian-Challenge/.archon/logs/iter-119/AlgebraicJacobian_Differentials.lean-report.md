# AlgebraicJacobian/Differentials.lean

## smooth_locally_free_omega (line 87, body L93–L136)

### Attempt 1 — Phase C Mathlib chain
- **Approach**: Followed the verified 5-step Mathlib chain in
  `STRATEGY.md` Phase C and `Differentials.tex` thm
  `smooth_locally_free_omega`:
  1. `smoothOfRelativeDimension_iff` (mk_iff) — extracts a chart `(U₀, V₀, e, hRing)`.
  2. `algebraize [CommRingCat.Hom.hom (Hom.appLE f U₀ V₀ e)]` —
     installs `Algebra Γ(S, U₀) Γ(X, V₀)` and
     `Algebra.IsStandardSmoothOfRelativeDimension n Γ(S, U₀) Γ(X, V₀)`.
  3. `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n` —
     yields `Algebra.IsStandardSmooth Γ(S, U₀) Γ(X, V₀)`.
  4. Synthesise `Nontrivial Γ(X, V₀)` from `x ∈ V₀` via
     `Scheme.component_nontrivial X V₀` and `Nonempty V₀ := ⟨⟨x, hxV⟩⟩`.
  5. Build the algebraic content:
     - `hfree : Module.Free Γ(X, V₀) Ω[Γ(X, V₀)⁄Γ(S, U₀)]` via
       `Algebra.IsStandardSmooth.free_kaehlerDifferential`.
     - `hrank : Module.rank Γ(X, V₀) Ω[Γ(X, V₀)⁄Γ(S, U₀)] = n` via
       `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential n`.
- **Result**: **PARTIAL** — Steps 1–5 land verbatim; the file compiles
  with a single remaining `sorry` at L136 (down from a bare `sorry` at
  L93 in the iter-118 signature). The blocking step is the
  *type-level identification* between the algebraic content and the
  presheaf-form section module — what the blueprint claims is
  "definitional equality" is not, in fact, definitional.

### The deep gap (Step 5 bridge)

The blueprint asserts that `M_U := (relativeDifferentialsPresheaf f).presheaf.obj (op V₀)`
is "definitionally equal" to `Ω_{B/A}` with `A := Γ(S, U₀)`, `B := Γ(X, V₀)`,
and that the free-of-rank-`n` conclusion "transfers verbatim." The
project-local lemma `relativeDifferentialsPresheaf_obj_kaehler`
(L58–L64, proof `rfl`) identifies `M_U` with
`CommRingCat.KaehlerDifferential (φ'.app (op V₀))` where
`φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction _ f.base).homEquiv _ _).symm f.c`.
The source of this ring map is **not** `Γ(S, U₀)` but rather
`((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op V₀)`,
which by the left Kan extension formula computes to
`colim_{W : Opens S, f V₀ ⊆ W} S.presheaf.obj W`. This is the
"inverse-image presheaf at V₀" — a colimit ring strictly larger than
`Γ(S, U₀)` in general.

Hence the two Kähler differential modules:
- `Ω[Γ(X, V₀) ⁄ Γ(S, U₀)]` (Mathlib-side, from `algebraize`)
- `Ω[Γ(X, V₀) ⁄ ((pullback f.base).obj S.presheaf)(op V₀)]` (project-side, from `relativeDifferentialsPresheaf`)

are **different types** as Lean elaborates them. The blueprint's
"definitional equality" claim conflates the colimit source with
`Γ(S, U₀)`, which would only be true if the colimit collapsed
(it does not, on the presheaf level).

The required bridge is a `LinearEquiv` of `Γ(X, V₀)`-modules between
the two. Constructing it:
- The surjection `Ω[B/Γ(S,U₀)] ↠ Ω[B/(f⁻¹OS)(V₀)]` is `KaehlerDifferential.map`
  ([`Mathlib.RingTheory.Kaehler.Basic`], surjective by
  `KaehlerDifferential.map_surjective`).
- Injectivity of this surjection (which would make it an iso) reduces
  to showing `image((f⁻¹OS)(V₀) → Γ(X, V₀)) ⊆ image(Γ(S, U₀) → Γ(X, V₀))`
  inside `Γ(X, V₀)`. This is the statement that every section of
  `f⁻¹ O_S` over `V₀`, when mapped to `Γ(X, V₀)` via `φ'.app`, also
  arises from a section of `S.presheaf` over `U₀` via `appLE`.
- That inclusion is true for the **sheafified** inverse image
  (since `S.presheaf` is a sheaf and one can refine to a cover of
  `f V₀` inside `U₀`), but the project uses the **presheaf-level**
  `TopCat.Presheaf.pullback` (a left Kan extension, not sheafified),
  so the argument requires explicit cofinality manipulation of the
  comma category indexing the Kan extension.

### What's required to close the sorry

A **project-local helper lemma** of roughly the following shape (not
yet in the file):
```
lemma relativeDifferentialsPresheaf_iso_kaehler_appLE
    (f : X ⟶ S) {U : S.Opens} {V : X.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V) (e : V ≤ f ⁻¹ᵁ U) :
    letI := (Scheme.Hom.appLE f U V e).hom.toAlgebra
    ((relativeDifferentialsPresheaf f).presheaf.obj (.op V) : Type _) ≃ₗ[Γ(X, V)]
      Ω[Γ(X, V) ⁄ Γ(S, U)]
```
The hypothesis `hU, hV : IsAffineOpen` is what enables the cofinality
argument (Stacks Tag 01HR-ish: affine bases make the presheaf-level
pullback agree with the sheafification on affine opens). Without
`IsAffineOpen` hypotheses, the iso is genuinely false (any
non-affine `V` would break the cofinality argument).

Within the autonomous-loop scope this helper amounts to ~50–150
LOC of presheaf/Kan-extension manipulation. The Mathlib pieces that
should suffice:
- `TopCat.Presheaf.pullbackObjObjOfImageOpen` (when `f V` is open in `S`,
  which holds for `f` smooth — Mathlib has `Smooth.isOpenMap` indirectly
  via `UniversallyOpen`, may not be in `b80f227`).
- `KaehlerDifferential.map`, `KaehlerDifferential.map_surjective`, and a
  hand-rolled injectivity argument via the image-containment.
- The colimit-cone universal property to factor `φ'.app V` through
  the `U` injection.

### Mathlib lemmas searched / used this iter

- **Used (success)**:
  - `AlgebraicGeometry.smoothOfRelativeDimension_iff` — verified;
    extracts the standard-smooth chart at `x`.
  - `algebraize` tactic with `RingHom.IsStandardSmoothOfRelativeDimension.toAlgebra`
    (`@[algebraize ...]`) — works as advertised, sets up both
    `Algebra` and `Algebra.IsStandardSmoothOfRelativeDimension`
    instances in one shot.
  - `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` —
    `(n : ℕ) → [Algebra.IsStandardSmoothOfRelativeDimension n R S] →
     Algebra.IsStandardSmooth R S`.
  - `Algebra.IsStandardSmooth.free_kaehlerDifferential` — instance.
  - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` —
    requires `[Nontrivial S]`, `n` explicit.
  - `AlgebraicGeometry.Scheme.component_nontrivial` — `[Nonempty U] →
     Nontrivial Γ(X, U)`.
- **Investigated but not used (would close the gap)**:
  - `TopCat.Presheaf.pullbackObjObjOfImageOpen` — direct iso when
    `f V` is open in `S`. Useful but needs `f.base` open.
  - `KaehlerDifferential.map_surjective` — surjection direction of the
    bridge.
- **Searched and not found in b80f227**:
  - `RingHom.IsStandardSmoothOfRelativeDimension.of_isLocalization_left`
    or similar — would let us transport standard-smoothness across
    the colimit injection.
  - A direct "smooth → UniversallyOpen → IsOpenMap" Mathlib instance —
    looked, did not find an automatic instance chain in `b80f227`;
    `IsSmooth → IsOpenMap` exists conceptually (smooth morphisms are
    open) but the instance is not registered as far as I could see.

### Next-session next step

Build the helper lemma `relativeDifferentialsPresheaf_iso_kaehler_appLE`
in this file (does not require modifying the protected signature). The
cleanest route is likely:
1. Use `TopCat.Presheaf.pullbackObjObjOfImageOpen` if a `Smooth →
   IsOpenMap (f.base)` bridge can be located or built (the iso then
   becomes essentially `pullbackObjObjOfImageOpen f.base S.presheaf V₀ _`
   composed with restriction `S.presheaf.obj (f V₀) → Γ(S, U₀)`,
   which is wrong-direction). Probably this route does not close
   straightforwardly.
2. Alternative: Directly establish the algebra-source iso
   `Γ(S, U₀) ≃+* ((pullback f.base).obj S.presheaf).obj (op V₀)`
   under `IsAffineOpen V₀, IsAffineOpen U₀`; transfer the algebraic
   content via `Module.Free.of_ringEquiv` /
   `Module.Free.iff_of_ringEquiv`. This requires the cofinality
   argument explicitly.

## Outcome summary

- **Status**: **PARTIAL** — major algebraic content of the forward
  implication is built; the final type-bridge is the remaining
  obstacle.
- **Sorry count delta on the file**: **1 → 1** (relocated from the
  bare body sorry at L93 to a structured-but-unresolved bridge sorry
  at L136). The proof body grew from 1 line to ~45 lines of real
  content (verifiable via `lean_diagnostic_messages`).
- **No new axioms**, no protected signatures touched, file compiles
  with only the expected `sorry` warning.
- **Blueprint marker assessment**: `\leanok` on the proof block at
  `Differentials.tex:62` is currently OPTIMISTIC — the proof has a
  remaining `sorry`. The deterministic `sync_leanok` phase
  should strip it (sorry > 0). Statement-block `\leanok` at
  `Differentials.tex:48` remains appropriate (declaration has body,
  even if body has a `sorry`).
- **Watch criterion for iter-120 plan agent** (per progress-critic-iter119):
  iter-119 outcome is **PARTIAL without a new mathematical blocker** — the
  blocker (presheaf vs. appLE algebra mismatch) is a *deferred technical
  step inside the existing route*, not a strategy-level dead end.
  This should map to iter-120 **UNCLEAR-trending-CONVERGING**: continue
  on the same route, dispatch a prover lane focused on the helper
  lemma above, polish lane permitted in parallel.
