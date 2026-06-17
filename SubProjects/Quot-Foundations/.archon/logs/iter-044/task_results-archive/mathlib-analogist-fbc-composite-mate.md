# Mathlib Analogist: fbc-composite-mate
**Mode:** api-alignment | **Iter:** 044

## Verdicts
- **Turnkey composite-mate lemma?** NO. The whole `conjugateEquiv`/`leftAdjointCompIso` API takes
  `adjL`, `adjR`, `β` (= the right-adjoint comparison) as **explicit mandatory inputs** — none are
  inferred. `Adjunction.comp` is **binary** (no n-ary `compₙ`, no `conjugateEquiv_compₙ`); a depth-5
  `adjL` is hand-nested `.comp`. So `adjL`/`adjR` assembly is genuinely required (but mechanical).
- **A single monolithic `β` is NOT required** (the multi-hundred-LOC trap is avoidable). `conjugateEquiv_symm_comp`
  (`Mates.lean`, `@[reassoc (attr := simp)]`):
  `(conjugateEquiv adj₂ adj₃).symm β ≫ (conjugateEquiv adj₁ adj₂).symm α = (conjugateEquiv adj₁ adj₃).symm (α ≫ β)`
  lets the section composite be discharged as a **composition of the three already-axiom-clean legs**
  (conj-2b/2c/2d) — β is the implicit `α ≫ β ≫ …`, never materialized as one term.
- **Deliverable = (a)** — a precise Mathlib-aligned shape exists; strong-form (b) is FALSE (no monolith
  forced), weak-form (b) TRUE (the `adjL`/`adjR` naming + per-layer chaining cannot be skipped).

## What telescopes a `.comp` conjugate (each peels ONE layer)
- `conjugateEquiv_comp` / `conjugateEquiv_symm_comp` (`Mates.lean`, both `@[reassoc simp]`) — fuse a
  vertical stack of conjugates over the same (C,D); THE chaining engine.
- `conjugateEquiv_whiskerLeft` / `conjugateEquiv_whiskerRight` (`Mates.lean`) — peel one outer/inner
  functor off a `.comp` conjugate; the `(Spec φ)_*` extra layer enters here (a whisker, NOT a positional
  naturality rewrite under the diamond, since `(Spec φ)_*` is itself a right adjoint).
- `conjugateEquiv_associator_hom` (`Mates.lean`) — reassociate depth-3 `.comp`.
- `conjugateEquiv_leftAdjointCompIso_inv` (`CompositionIso.lean:82`, `@[simp]`) — direct composite-vs-single
  recognition IF the factor was built as `leftAdjointCompIso` (conj-2b/conj-0′ already arrange this).
- `leftAdjointCompNatTrans₀₁₃_/₀₂₃_eq_conjugateEquiv_symm` (`CompositionIso.lean:130/140`) — the ONLY
  genuine "telescope multi-functor composite → one `(conjugateEquiv adj₀₃ (adj₀₁.comp (adj₁₂.comp adj₂₃))).symm`"
  lemmas, but **hard-capped at depth 3** and require each leg pre-encoded as `leftAdjointCompNatTrans`.
  Their proof IS the template: `surjective`×2 → `apply (conjugateEquiv …).injective` → one `simp`.

## Precise target for a future mathlib-build lane (factored route, not monolith)
1. `set adjL`/`adjR` as nested `Adjunction.comp` over the layers (mirror conj-2d:1667-1670, two layers
   deeper: `tilde⊣Γ_R`, `(Spec φ)^*⊣(Spec φ)_*`, `g'^*⊣g'_*` | `extend⊣restrict_ψ`, `tilde⊣Γ_{R'}`). Mechanical.
2. Split the section LHS into per-layer conjugate factors via `conjugateEquiv_symm_comp` +
   `Adjunction.comp_unit_app` (= conj-2d's `hunitL`/`hunitR`); the extra `(Spec φ)_*` layer via
   `conjugateEquiv_whiskerLeft`/`_whiskerRight`.
3. `apply (conjugateEquiv adjL adjR).injective`; close with `simp/rw` over
   `[conjugateEquiv_symm_comp, conjugateEquiv_comp, conjugateEquiv_whiskerLeft, conjugateEquiv_whiskerRight,
   conjugateEquiv_associator_hom, conjugateEquiv_leftAdjointCompIso_inv, unit_conjugateEquiv_symm]` +
   the three legs. Lock-prone factors are metavars via `surjective … rfl`, so the `X.Modules` diamond never bites.
- First reads: `CompositionIso.lean:130-179` (the `₀₁₃`/`₀₂₃`/`_assoc` trio); `Mates.lean`
  `conjugateEquiv_symm_comp`/`_whiskerLeft`/`_whiskerRight`. First project edit:
  `FlatBaseChange.lean:1815+` (after the existing `rw`+`simp only`), introduce `adjL`/`adjR`, drive LHS to
  `(conjugateEquiv adjL adjR).symm (…)` by `conjugateEquiv_symm_comp`.

## Discarded
- One-shot monolithic depth-5 `adjL`/`adjR`/`β` + single `.injective` (project's current path, 7 iters):
  divergent-with-cost — the bespoke β is the trap. Replace with the factored `conjugateEquiv_symm_comp` chain.
- `iterated_mateEquiv_conjugateEquiv` (`Mates.lean`) — only certifies iso-ness (already free via `conjugateIsoEquiv`); does not close the coherence.

## Persistent file
- `analogies/fbc-composite-mate-recognition.md` written.

Overall verdict: No turnkey lemma; `adjL`/`adjR` assembly is unavoidable-but-mechanical, a monolithic `β`
is NOT required — chain the three axiom-clean legs via `conjugateEquiv_symm_comp` exactly as
`leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` does.
