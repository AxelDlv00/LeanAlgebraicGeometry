# Blueprint Writer Directive — Picard_TensorObjSubstrate.tex

## Target chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the ONLY chapter you edit).

## Strategy context (the slice that matters)

Lane TS builds the abelian-group law on the relative Picard functor. For 4 iters
the chapter's critical path ran through `tensorObj_restrict_iso` ("⊗ commutes with
restriction along an open immersion"), which bottoms out in the opaque
`PresheafOfModules.pullback` abstract left adjoint (~200–300 LOC of absent Mathlib
infra). A mathlib-analogist consult (iter-209, `analogies/tsconstruct209.md`,
ALIGN_WITH_MATHLIB, critical) established that this difficulty is an **artifact of
the wrong predicate**: the group law was being built on the *geometric* predicate
`IsLocallyTrivial M ≡ ∀ x, ∃ affine U ∋ x, M.restrict U.ι ≅ 𝒪_U`, which forces a
comparison of a globally-sheafified `⊗` against a local restriction. Mathlib's
Picard-group idiom (`Mathlib.RingTheory.PicardGroup`: `Module.Invertible`,
`CommRing.Pic = Units (Skeleton (ModuleCat R))`, `instCommGroupPic`) instead uses
**⊗-invertibility**: a line object is one with `∃ N, M ⊗ N ≅ 𝒪`. Under that
predicate the group law needs only the monoidal coherence isos of `⊗` (associator,
unitors, braiding) and the inverse is carried by the predicate itself —
`tensorObj_restrict_iso` and `exists_tensorObj_inverse` are **not needed**.

This reverts to the project's OWN documented intent: `LineBundlePullback.lean:50–58`
says `OnProduct` will be "a structure pairing a carrier with an `IsInvertible`
witness once that predicate is ... proven internally", and `IsLocallyTrivial` is
described there as "the project-side stand-in for the missing Mathlib `IsInvertible`
predicate". You are supplying that `IsInvertible` predicate and the group law on it.

## Required rewrite (definitions/theorems that must be present, with detail to formalize)

Rewrite the chapter so the **critical path to the group law** is the ⊗-invertibility
construction below. Keep the existing `def:scheme_modules_tensorobj` (the `⊗` object,
`= sheafification ∘ PresheafOfModules.Monoidal.tensorObj`) — the analogist confirms
this object definition is the correct Mathlib shape (PROCEED). Add/restate:

1. **`IsInvertible` predicate** (new block, e.g. `def:scheme_modules_isinvertible`,
   `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}`):
   `IsInvertible (M : X.Modules) : Prop := ∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`.
   This is the `Module.Invertible` analogue. Note it is a Prop carrying the inverse
   existentially — so the dual/inverse is definitional, no `exists_tensorObj_inverse`.

2. **Three monoidal coherence isos of `tensorObj`** (new blocks), each built by the
   already-validated cheap pattern `sheafification.mapIso (PresheafOfModules.Monoidal.<iso>)`
   — exactly the shape of the existing `tensorObj_unit_iso` and `tensorObjIsoOfIso`
   (no `pullback`, no opaque adjoint, ~15 LOC each):
   - **associator** `tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)` (from `α_`);
   - **left/right unitors** `tensorObj 𝒪 M ≅ M`, `tensorObj M 𝒪 ≅ M` (from `λ_`/`ρ_`, plus the
     sheafification-counit step as in `tensorObj_unit_iso`);
   - **braiding/symmetry** `tensorObj M N ≅ tensorObj N M` (from `β_`).
   Give each a `\lean{...}` pin with a plausible name (e.g. `tensorObj_assoc_iso`,
   `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding`).

3. **The commutative monoid of ⊗-iso-classes and its units group** (new block, the
   group-law engine): describe assembling a `CommMonoid` whose elements are
   isomorphism classes of `X.Modules` under `tensorObj` (multiplication = `tensorObj`,
   well-defined via `tensorObjIsoOfIso`; unit = class of `𝒪_X`; associativity /
   unit / commutativity from the coherence isos of (2)), mirroring Mathlib's
   `CommRing.Pic = Units (Skeleton (ModuleCat R))` / `instCommGroupPic`. The Picard
   group is the **units** of this monoid, and an element is a unit iff its carrier is
   `IsInvertible`. Cite the Mathlib idiom as the *design template* (not a math source).

4. **Re-point the group-law theorem** `thm:rel_pic_addcommgroup_via_tensorobj`
   (`\lean{...addCommGroup_via_tensorObj}`): its `AddCommGroup` on the relative Picard
   quotient is now obtained from the units-of-the-monoid-of-iso-classes structure of (3)
   (transported through `QuotientAddGroup` / the `preimage_subgroup` Setoid, whose
   relation `L ~ L' ↔ L ⊗ (L')⁻¹ ∈ π_T^* Pic(T)` already presupposes ⊗ and the
   ⊗-inverse). The four-existence-of-iso-lemmas-on-a-geometric-subtype plan is replaced.

5. **`OnProduct` re-point note**: state that the downstream carrier `OnProduct`
   (in `chap:Picard_LineBundlePullback`) will be re-instantiated as
   `{ M : (pullback πC πT).Modules // IsInvertible M }` (the iter-174 documented
   intent), and that `IsLocallyTrivial` is retained as a *separate* predicate connected
   to `IsInvertible` later by an OFF-critical-path equivalence (only the geometric
   `IsInvertible ⟸ IsLocallyTrivial`-style direction is nontrivial; it is NOT needed
   for the group law). Do NOT rewrite the LineBundlePullback chapter — just reference
   the planned re-point so this chapter is self-consistent.

## Must-fix items to resolve in this rewrite (from lean-vs-blueprint-checker ts-iter208)

- **Remove the disproven sectionwise-unfolding route** for `tensorObj_restrict_iso`
  from the MAIN prose: Step 3 of the proof block (~lines 489–530) and the closing
  "30–60 line helper" paragraph (~lines 529–539). `tensorObj_restrict_iso` is now
  OFF the critical path: demote it to an optional `% NOTE`-flagged remark stating it
  is no longer required for the group law (the group law uses ⊗-invertibility, not
  geometric local triviality). Do the same for `exists_tensorObj_inverse`.
- **Remove the secondary disproven-route occurrences**: the API-survey-section intro
  (~lines 155–177) and the "LOC estimates, Piece 2" section (~lines 963–990) both
  still assert the "bounded sectionwise unfolding of `PresheafOfModules.pullback` …
  ~30–60 LOC" route. Replace with the ⊗-invertibility critical path; if you keep any
  LOC estimate, base it on the (2)+(3) construction (3 coherence isos ~15 LOC each +
  the monoid/units assembly), not the abandoned route.

## Citation discipline (mandatory — read the local source, quote verbatim)

The mathematical content "isomorphism classes of invertible sheaves on a scheme form
an abelian group under ⊗ (the Picard group), and pullback/⊗ respect it" is sourced
from **Stacks tag 01CR (Picard group of a scheme)** and **01HK (invertible modules)**,
and **Kleiman, "The Picard scheme", §2** (relative/absolute Picard functor). For each
externally-sourced block add `% SOURCE:`, `% SOURCE QUOTE:` (verbatim, original
notation), and a visible `\textit{Source: …}` line, per the citation rules. If you do
NOT already have the Stacks Picard-group tag text locally under `references/`, you are
authorized to dispatch a `reference-retriever` child (your `--write-domain` includes
`references/**`) to fetch the Stacks "Divisors"/"Picard group" chapter (tag 01CR) and
the invertible-modules tag (01HK); WAIT for it, read the downloaded source, then quote
verbatim. The Mathlib `CommRing.Pic`/`Module.Invertible` reference is a *design
template*, not a math source — mention it in prose as the alignment idiom, no SOURCE
quote needed for it.

## Out of scope (do NOT do)
- Do NOT edit any chapter other than `Picard_TensorObjSubstrate.tex`.
- Do NOT add or remove `\leanok` / `\mathlibok` markers (deterministic sync owns them).
- Do NOT delete the `def:scheme_modules_tensorobj` object definition or the existing
  `tensorObjIsoOfIso` / `tensorObj_unit_iso` helper descriptions — they are the
  validated cheap pattern the coherence isos copy.
- Do NOT write Lean tactic code. Mathematical prose + `\lean{}`/`\uses{}` only.
- Do NOT speculate beyond the construction above (no new routes, no MonoidalClosed,
  no `pullback`-based proof).

## Strategy-modifying findings
If, while drafting, you find the ⊗-invertibility construction needs something the
above does not list (e.g. the `CommMonoid`-of-iso-classes assembly hits a Mathlib gap
in `CategoryTheory.Skeleton`), report it under a `## Strategy-modifying findings`
section in your report rather than inventing a workaround in the chapter.
