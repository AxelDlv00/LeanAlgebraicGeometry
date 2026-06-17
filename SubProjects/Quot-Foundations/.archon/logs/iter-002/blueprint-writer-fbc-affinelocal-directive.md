# Blueprint Writer Directive

## Slug
fbc-affinelocal

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Strategy context

This chapter is the FBC sub-leg: the i=0 flat-base-change isomorphism
`g^* f_* F ⟶ f'_* g'^* F` for a quasi-coherent sheaf, proved via a direct-on-sections affine
lemma (reducing to Mathlib's `cancelBaseChange`) and a Čech-free globalization. The affine-local
reduction lemma `lem:base_change_map_affine_local` is the FBC-A frontier node about to be handed
to a prover, but its proof sketch currently ASSERTS its key naturality step instead of deriving
it, so the blueprint review marked the chapter `correct: partial` and the HARD GATE blocks the
prover until this is fixed. Your single task is to repair that one proof so the prover has a
genuine, formalizable derivation.

## Required content

**Repair ONLY the proof of `lem:base_change_map_affine_local`** (currently lines ~886–909, the
`\begin{proof} … \end{proof}` block whose statement is at `\label{lem:base_change_map_affine_local}`).

The current proof ends with the sentence beginning "the section functor over \(U\) carries the
original base-change map to this restricted one, **because `pushforwardBaseChangeMap` is built from
the (pullback ⊣ pushforward) units and counits, all of which commute with restriction to an
open**. Granting this base-change-of-the-base-change-map compatibility — itself absent from the
pinned Mathlib and recorded here as the named obligation — …". This is an assertion, not a
derivation. Replace the asserted "Granting this …" hand-wave with an explicit derivation of the
naturality/compatibility step, so a prover knows whether the reduction is definitional + naturality
(it is) or needs a non-trivial coherence lemma (it does not).

The derivation must spell out, in mathematical prose (no Lean tactics):

1. **Unfold the definition of the map.** Per `def:pushforward_base_change_map`,
   `pushforwardBaseChangeMap` is the image, under the `(g^*, g_*)`-adjunction transpose (i.e. the
   adjunction bijection `Hom(g^* A, B) ≅ Hom(A, g_* B)`), of the morphism
   `f_* F → g_* f'_* (g')^* F = f_* (g')_* (g')^* F` obtained by applying `f_*` to the unit
   `η_F : F → (g')_* (g')^* F` of the `((g')^*, (g')_*)`-adjunction, using the square's
   commutativity `g ∘ f' = f ∘ g'`. State this as the starting point of the derivation.

2. **Restriction to an affine open `U ⊆ S'` is a functor that commutes with the building blocks.**
   The restriction-to-`U` (equivalently, the section functor `Γ(U, −)` composed with the open
   immersion `U ↪ S'`, or the pullback along `U ↪ S'`) is a functor; the adjunction unit `η`,
   the pushforward functors `f_*`, `(g')_*`, and the adjunction transpose `(g^*, g_*)` are all
   natural transformations / natural bijections. Naturality means: applying the restriction
   functor to a transpose-of-a-unit-composite equals the transpose-of-the-unit-composite of the
   restricted data. Concretely: (a) the unit `η_F` restricts to the unit of the restricted
   adjunction on the restricted square; (b) `f_*` of a restricted morphism is the restriction of
   `f_*` of the morphism (pushforward commutes with restriction to an open of the base, because
   `(f_* G)|_U = (f|_{f^{-1}U})_* (G|_{f^{-1}U})` for an open `U` of the base); (c) the
   `(g^*, g_*)`-transpose is natural in both variables. Chaining these three naturalities gives
   that the restriction of `pushforwardBaseChangeMap` to `U` equals `pushforwardBaseChangeMap` of
   the restricted cartesian square — i.e. `(pushforwardBaseChangeMap …).app U` IS the
   affine–affine base-change map on the square cut out over `U` (and a chosen affine
   `Spec R ⊆ S` containing `g(U)`).

3. **Conclude the reduction.** Therefore the per-affine-open hypothesis of
   `lem:modules_isIso_iff_affineOpens` — that each `(pushforwardBaseChangeMap …).app U` is an
   isomorphism — is, after the identifications of step 2, exactly the affine–affine section
   assertion supplied by `lem:pushforward_base_change_mate_cancelBaseChange`. Apply the locality
   criterion `lem:modules_isIso_iff_affineOpens` to conclude `IsIso (pushforwardBaseChangeMap …)`.

The point the writer must make unambiguous for the prover: **this compatibility is NOT a new
coherence theorem — it is the naturality of the adjunction transpose together with the standard
fact that pushforward along `f` commutes with restriction to an open of the base.** Remove the
"itself absent from the pinned Mathlib and recorded here as the named obligation" framing; the
obligation is the naturality bookkeeping, which is discharged by unfolding + naturality, not by an
external lemma. If, in spelling this out, you judge that one specific naturality fact (e.g.
"pushforward commutes with restriction to an open") deserves to be its own named helper block with
a `\lean{}` hint so the prover can target it separately, you MAY add such a helper lemma block to
this chapter (concise statement, `\label`, `\uses`, one-line proof) and cite it from the proof —
but only if it genuinely sharpens the prover's target; do not pad.

Keep the existing `% SOURCE:` / `% SOURCE QUOTE:` (Stacks "local on S and S'" step) on the lemma
statement — that quote is faithful and stays. The derivation you add is the project's elaboration
of that one-sentence Stacks step, so it is Archon-original prose inside `\begin{proof}` and needs
no new verbatim source quote (the Stacks proof gives only the one sentence already quoted). Do NOT
fabricate a longer Stacks quote.

## Out of scope

- Do NOT touch any other declaration block. The other FBC declarations
  (`lem:pushforward_base_change_mate_cancelBaseChange`, `lem:affine_base_change_pushforward`,
  `thm:flat_base_change_pushforward`, the tilde-dictionary lemmas, the locality lemmas) were
  reviewed as prover-ready — leave them exactly as they are.
- Do NOT change the lemma's `\lean{}` pin (it stays `AlgebraicGeometry.TODO.base_change_map_affine_local`
  — the scaffold pass repoints it later).
- Do NOT add `\leanok`.

## References

- `references/stacks-coherent.tex`: the proof of the "Affine base change" lemma (Cohomology of
  Schemes), L920–926 ("local on S and S'" step) and the base-change-diagram definition L877–904.
  You already have the relevant verbatim quotes in the chapter; consult the file only if you want
  to confirm the Stacks proof says no more than the one sentence about locality.

## Expected outcome

The proof of `lem:base_change_map_affine_local` now contains an explicit three-step derivation
(unfold the transpose-of-unit definition; apply naturality of the transpose + pushforward-commutes-
with-restriction; conclude via the locality criterion) that a prover can formalize, with the
"named obligation absent from Mathlib" framing removed. The chapter should then read `correct: true`
on a re-review.
