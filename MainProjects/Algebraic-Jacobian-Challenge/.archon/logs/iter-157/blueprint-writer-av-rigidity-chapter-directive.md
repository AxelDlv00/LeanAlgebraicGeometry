# Blueprint Writer Directive

## Slug
av-rigidity-chapter

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex  (NEW FILE — create it)

This chapter is the dedicated home for the project's **committed genus-0 route (c)**: the
characteristic-free abelian-variety rigidity stack. The blueprint-reviewer (iter157)
directed that this stack get its OWN chapter (1:1 with a new upstream Lean file
`AlgebraicJacobian/AbelianVarietyRigidity.lean`), NOT a consolidated cover on Jacobian.tex.

At the very top of the new chapter, after `\chapter{...}\label{chap:AbelianVarietyRigidity}`,
declare coverage with the FULL repo-root-relative path:

    % archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean

## Strategy context (the slice that matters)
The genus-0 Jacobian arm has a TRIVIAL witness object (`J = Spec k`); its only remaining
mathematical content is a rigidity STATEMENT: "every pointed morphism from a genus-0 curve
over `k̄` to a smooth proper group scheme (abelian variety) `A` is constant (factors through
the identity point)." This is consumed by `genusZeroWitness.key` in `Jacobian.lean` (after a
`k̄ → k` descent step that lives in Jacobian.tex, NOT here).

The project commits to proving it CHARACTERISTIC-FREE, because the protected goal is over an
arbitrary `[Field k]`. (The cheaper differential `df=0` route — via the elementary
`H⁰(ℙ¹,Ω)=H⁰(ℙ¹,O(−2))=0` — dies on a char-`p` Frobenius-descent wall; the rigidity-lemma
route sidesteps it. Do NOT use the `df=0`/Serre framing in this chapter.)

## Required content — the MINIMAL chain (your first task is to determine it)

The chain, from Mumford + Hartshorne + Milne (all in tree). **Your most important job:
determine from MUMFORD whether `ℙ¹ → A constant` needs the theorem of the cube, or only the
cube-free Rigidity Lemma.** The reference-retriever found that Mumford's Rigidity Lemma
(Form I, §4 p.43) is a properness/closedness argument that does NOT use the cube, and that
Mumford leaves "no rational curves / `ℙ¹→A` constant" as a CONSEQUENCE of the rigidity lemma
+ corollaries — i.e. likely cube-free for a single `ℙ¹` factor (the cube / Cor 1.5 enters
only the multi-factor unirational induction, which a single curve avoids). Read Mumford §4
(PDF pp.54–56) and confirm or refute this. Structure the chapter around the MINIMAL chain:

1. **`thm:rigidity_lemma`** — `\lean{AlgebraicGeometry.rigidity_lemma}`. The Rigidity Lemma:
   let `V` be a complete (proper) variety, `W` any variety, both over `k`, with `V × W`
   geometrically irreducible and a point `(v₀,w₀)`; let `α : V × W → Z` be a morphism with
   `α(V × {w₀})` a single point. Then `α` factors through the projection `V × W → W` (i.e.
   `α` depends only on the `W`-coordinate). PROVER-READY detail: this is the iter-158 prover
   entry, so give the full proof (Mumford Form I, §4 p.43 / Milne Thm 1.1): pick an affine
   open `U ∋ α(v₀,w₀)`; `V` complete ⟹ the projection `q : V × W → W` is closed; the set of
   `w` with `α(V × {w}) ⊆ U` is open and nonempty; on it `α(V × {w})` is a complete connected
   subvariety of an affine, hence a point; conclude `α` is constant on each `V`-fibre over a
   dense open, then everywhere by separatedness/irreducibility. Spell out each step.

2. **`prop:morphism_P1_to_AV_constant`** — `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}`.
   Every morphism `f : ℙ¹_{k̄} → A` to an abelian variety (smooth proper group scheme) is
   constant. Derive from `thm:rigidity_lemma` (Milne Prop 3.10's packaged corollary). Give the
   proof at the granularity Mumford/Milne use; if it genuinely needs the cube, state the cube
   as `thm:theorem_of_the_cube` and `\uses` it, but PREFER the cube-free derivation if you can
   confirm one from Mumford. (If you keep the cube, mark `thm:theorem_of_the_cube` clearly as a
   DEFERRED deep input with no full proof yet, and add a `% NOTE:`-free prose flag that it is
   the heavy un-built prerequisite.)

3. **`prop:genusZero_curve_iso_P1`** — `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}`. A
   smooth proper geometrically irreducible curve of genus 0 over `k̄` (which has a `k̄`-rational
   point) is isomorphic to `ℙ¹_{k̄}`. Source: Hartshorne Example IV.1.3.5 / Exercise IV.1.3
   (genus = `dim H¹(O)`, Prop IV.1.1; Riemann–Roch gives a degree-1 divisor ⟹ iso to `ℙ¹`).
   This is Riemann–Roch-flavoured and Mathlib has no Riemann–Roch — so write the statement +
   proof SKETCH at textbook level (cite Hartshorne), and flag in the prose that its
   formalization is itself a sub-build (do not pretend it is short). `\lean{}` target present.

4. **`thm:rigidity_genus0_curve_to_AV`** — `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}`.
   THE HEADLINE the genus-0 arm consumes. A pointed morphism `f : C → A` (with `f` killing the
   marked point) from a smooth proper geometrically irreducible genus-0 curve `C` over `k̄` to a
   smooth proper geometrically irreducible group scheme `A` over `k̄` equals the constant
   morphism at the identity. Proof: compose `prop:genusZero_curve_iso_P1` with
   `prop:morphism_P1_to_AV_constant`; the pointed hypothesis pins the constant value to the
   identity. Characteristic-free: `[IsAlgClosed k̄]` only, NO `[CharZero]`. Note explicitly that
   this is the char-free replacement for the existing `rigidity_over_kbar` (which carries
   `[CharZero]` and lives in RigidityKbar.lean as the fallback-(a) artifact).

### Lean signature guidance (for the `\lean{}` targets / scaffolding)
- All declarations live in the NEW file `AlgebraicJacobian/AbelianVarietyRigidity.lean`,
  which will import `AlgebraicJacobian.Genus` and be imported by `AlgebraicJacobian.Jacobian`
  (this breaks the current `RigidityKbar → Rigidity → Jacobian` import cycle that blocks
  `genusZeroWitness` from consuming the keystone).
- `thm:rigidity_genus0_curve_to_AV`'s signature should mirror the existing
  `AlgebraicGeometry.rigidity_over_kbar` (in `RigidityKbar.lean`) MINUS the `[CharZero k̄]`
  instance — same curve/group-scheme typeclasses, same pointed-morphism conclusion shape
  (`f = toUnit C ≫ η[A]`). You do NOT write Lean; just describe the intended statement clearly
  enough that a scaffolder can transcribe the signature. Mention the `rigidity_over_kbar`
  signature as the template.

## Citation discipline — IMPORTANT, the sources are SCANNED images
Per the reference-retriever cards:
- `references/mumford-abelian-varieties.pdf` — SCANNED, **no text layer**. Rigidity Lemma
  (Form I) + corollaries at **PDF page 54** (book §4 p.43); AV definition/conventions PDF p.50
  (book p.39); Theorem of the Cube **PDF page 66** (book §6 p.55). Offset = book + 11.
- `references/hartshorne-algebraic-geometry.pdf` — SCANNED, no text layer. genus-0 ≅ ℙ¹
  **PDF page 314** (Example IV.1.3.5, doc p.297) + Exercise IV.1.3; genus = dim H¹(O) Prop
  IV.1.1 PDF p.311. Offset = doc + 17.
- `references/abelian-varieties.pdf` (Milne) — SCANNED. Prop 3.10 at **PDF page 26**; Rigidity
  Thm 1.1 PDF p.14.

To produce verbatim `% SOURCE QUOTE:` text you MUST open the actual PDF page with the Read
tool's `pages` parameter (e.g. `pages: "54"` on the Mumford PDF) and TRANSCRIBE the statement
from the rendered page image. Do NOT quote from memory and do NOT quote the `.md` pointer
cards (they carry no quotable text). Each block needs: `% SOURCE: <pointer>, <loc> (read from
references/<file>.pdf)`, a verbatim `% SOURCE QUOTE:` (and `% SOURCE QUOTE PROOF:` before the
proof env where the source gives a proof), and a visible `\textit{Source: ...}` first line.
If a specific page genuinely will not render, flag that block `% SOURCE: ... (verbatim text
not yet retrieved — page did not render)` and leave the statement in project notation without
a fabricated quote — do NOT invent the verbatim text.

## Macros
`\mathbb P`, `\Spec`, `\bar k`, `\genus` are already used elsewhere; `\dashrightarrow` is from
amssymb (loaded). Define any NEW macro you need in `blueprint/src/macros/common.tex`? — NO:
you may only edit your assigned chapter. If you need a new macro, use an inline `\ensuremath`
or a local `\newcommand` at the top of YOUR chapter, and note it in your report.

## Out of scope
- Do NOT edit `Jacobian.tex` or `RigidityKbar.tex` (the plan agent strips the duplicated
  route-(c) blocks from `Jacobian.tex` and reframes `RigidityKbar.tex` separately). Use the
  SAME label names the current `Jacobian.tex` `sec:av_rigidity_route_c` uses where they carry
  over (`thm:theorem_of_the_cube`, `prop:rigidity_genus0_curve_to_AV`) so existing `\cref`s
  resolve to your new chapter — EXCEPT introduce the new minimal-chain labels above
  (`thm:rigidity_lemma`, `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`).
- Do NOT touch `content.tex` (plan agent adds the `\input`).
- Do NOT add `\leanok` or `\mathlibok` markers (managed by sync_leanok / review).
- Do NOT develop the positive-genus Albanese UP or Route A here.

## References
- `references/mumford-abelian-varieties.md` (pointer; PDF page map) → quote from the PDF.
- `references/hartshorne-algebraic-geometry.md` (pointer) → quote from the PDF.
- `references/abelian-varieties.md` (Milne pointer) → quote from the PDF.
- For the existing label/prose to carry over, you MAY read `blueprint/src/chapters/Jacobian.tex`
  `sec:av_rigidity_route_c` (lines ~449–595) as a STARTING POINT, but re-ground every proof in
  Mumford/Hartshorne (the current blocks cite only Milne's terse notes, which the reviewer
  flagged as too thin for the cube and rational-map-extends).
