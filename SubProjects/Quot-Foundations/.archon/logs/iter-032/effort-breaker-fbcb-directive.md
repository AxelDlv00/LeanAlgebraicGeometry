# Effort-breaker directive — FBC-B globalization (slug: fbcb)

Chapter: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (ONLY this file).

## Target

`thm:flat_base_change_pushforward` (`\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}`, block
at ~line 3118; proof sketch ~lines 3240–3331). This is FBC-B: the globalization of the affine base-change
iso to a flat `g`, quasi-compact + quasi-separated `f`, via the Čech-free "H⁰ as the sheaf-condition
equalizer of a finite affine cover, and flat `−⊗B` preserves that finite equalizer" argument.

## Why now

FBC-B's content is INDEPENDENT of the FBC-A `_legs` crux (which is walled on the `X.Modules` instance
diamond, ~14 iters over budget). The strategy is to run FBC-B as a PARALLEL lane in a split-out file
rather than serialize it behind FBC-A. To do that, FBC-B must first be decomposed into `\uses`-linked
sub-lemmas that a prover can pick up bottom-up. That decomposition is your job.

## Granularity

One level — the proof's main steps. The single highest-value cut is to isolate the **project-side
infrastructure that does NOT yet exist and is buildable now from Mathlib**:

- the "**H⁰ of a `SheafOfModules` as the equalizer of the sheaf condition over a finite affine cover**"
  packaging (degree-0/1 Čech equalizer; needs QC + QS to get a *finite* cover and finite overlaps). This
  is the genuinely missing project infrastructure; cut it into its own sub-lemma(s) with a precise
  statement (a finite affine cover `{Uᵢ}` of `X`, `Γ(X,F) = eq(∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F))`).
- the base-change compatibility: the cover `{Uᵢ}` pulls back to a finite affine cover of `X_B`, and the
  base-changed equalizer diagram is `(−⊗_A B)` applied to the original — a sub-lemma.
- the assembly: combine `lem:affine_base_change_pushforward` (per-`Uᵢ` and per-`Uᵢⱼ`),
  `lem:flat_preserves_equalizer_mathlib` (already a Mathlib anchor), and the two packaging sub-lemmas
  to conclude `IsIso (pushforwardBaseChangeMap …)`.

Keep `lem:flat_preserves_equalizer_mathlib` as the existing Mathlib anchor — do NOT re-break it. For each
new sub-lemma: statement, `\label`, `\lean{}` pin (a plausible `AlgebraicGeometry.…` name the prover will
create), accurate `\uses{}`, and a one-line informal proof. Wire `thm:flat_base_change_pushforward`'s
`\uses{}` to the new sub-lemmas.

## Proof structure to cut along

Stacks 02KH part (2) / the existing sketch at lines 3240–3331: (i) reduce `H⁰(S,f_*F)=Γ(X,F)` and the
base-change side `H⁰(X_B,F_B)=Γ(X_B,F_B)`; (ii) present `Γ(X,F)` as the finite sheaf-condition equalizer
(QC ⇒ finite cover, QS ⇒ finite affine overlaps); (iii) the affine lemma gives the iso on each `Uᵢ` and
`Uᵢⱼ`; (iv) flatness commutes `−⊗B` past the finite equalizer.

## Out of scope

- Do NOT touch FBC-A blocks (`lem:base_change_mate_fstar_reindex_legs`, `_gstar_transpose`,
  `lem:affine_base_change_pushforward`) — they are a separate, walled crux.
- Do NOT add `\leanok`. `\mathlibok` only on a genuine Mathlib anchor (e.g. if a finite-equalizer or
  QS-finite-overlap fact is literally in Mathlib, anchor it; otherwise leave it as a to-build sub-lemma).
- Report (in "Could not complete") any sub-lemma whose informal proof you cannot write because the
  packaging genuinely needs a Mathlib sheaf-condition API you cannot locate — that becomes a strategy item.
