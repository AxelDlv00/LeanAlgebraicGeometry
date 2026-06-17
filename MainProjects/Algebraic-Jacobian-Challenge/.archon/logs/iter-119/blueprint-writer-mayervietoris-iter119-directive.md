# Blueprint Writer Directive

## Slug
mayervietoris-iter119

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Strategy context

The project went through an aggressive TRIM at iter-117. Specifically,
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean` was **deleted in
its entirety** (along with `Modules/Monoidal.lean`,
`Picard/{LineBundle,Functor}.lean`), and `Differentials.lean` was
rewritten from ~1100 LOC to ~95 LOC retaining only the relative
cotangent presheaf + forward direction of the smoothness criterion.

The Mayer-Vietoris chapter currently runs ~1180 lines and is split
into two halves:

- **Lines 1–940**: describe `MayerVietorisCore.lean` and
  `MayerVietorisCover.lean` (the live files: MV LES, two-affine
  covers, whole-space cohomology, finite-rank consequences, comparison-
  iso scaffolding classes `HasCechToHModuleIso` and
  `HasAffineCechAcyclicCover`). This half is correct and aligned with
  the surviving Lean.

- **Lines 941–1180**: describe `BasicOpenCech.lean` content
  (`basicOpenCover` definition, basic-open infrastructure, finite-
  intersection helpers, the iter-108 Čech-acyclicity recipe with its
  "iter-108 escape-valve" remark enumerating SEVEN named deferrals,
  six of which point at deleted files). **All of this content
  describes Lean code that no longer exists.** Cross-check:
  - `BasicOpenCech.lean`: deleted (not in `AlgebraicJacobian/Cohomology/`).
  - `Modules/Monoidal.lean`: deleted.
  - `Picard/LineBundle.lean`, `Picard/Functor.lean`: deleted.
  - `Differentials.lean` line numbers like 636 (`h_exact`), 877
    (`serre_duality_genus`): deleted from the post-iter-117 file
    (only L87 `smooth_locally_free_omega` survives in
    `Differentials.lean`).
  - `Jacobian.lean:179` `nonempty_jacobianWitness`: still present as
    the single foundational hypothesis — this one item alone in
    the iter-108 escape-valve list is still live.

The post-iter-117 reality is: the project keeps a subset of cohomology
machinery (`Cohomology/SheafCompose.lean`,
`Cohomology/StructureSheafAb.lean`,
`Cohomology/StructureSheafModuleK.lean`,
`Cohomology/MayerVietorisCore.lean`,
`Cohomology/MayerVietorisCover.lean`) and prunes the basic-open-cover
substep. The genus-finiteness chain bottoms out at the unproduced
scaffolding classes `HasCechToHModuleIso` / `HasAffineCechAcyclicCover`
documented honestly in the chapter (Sections \ref{sec:cech_acyclicity}
subsections "Comparison-iso typeclass carrier" and "Affine Čech-acyclic
cover carrier"). Those classes have no producer in the project and
this is acknowledged.

## Required content

Your job is to **remove the orphan content** in lines 941–1180 and
leave the chapter with only content that maps to live Lean code.

Concretely:

1. **Delete entirely** the section `\section{Basic-open cover
   infrastructure}` (currently L941) and everything that follows it
   in the chapter, including:
   - All `\begin{definition}` / `\begin{theorem}` blocks naming
     `\lean{AlgebraicGeometry.Scheme.basicOpenCover...}` (deleted Lean
     names; do not survive).
   - The section `\section{Čech acyclicity for the structure sheaf on
     affine basic-open covers}` (currently L1089), with its theorem
     `\lean{...basicOpenCover_isCechAcyclicCover_toModuleKSheaf}` and
     proof (all references to deleted Lean code).
   - The remark `\begin{remark}[Implementation status (iter-108
     escape-valve)]` at L1167 (refers to multiple deleted files and a
     deleted line in `Differentials.lean`).
   - The subsection `\subsection{Use in the project}` at L1174 with
     its `\paragraph{Status (iter-108 / Archon canonical iter-108).}`
     paragraph — both reference `BasicOpenCech.lean`.

2. **Preserve unchanged** everything from L1 through the end of the
   subsection `\subsection{Affine Čech-acyclic cover carrier}` at
   L915. This first half is correct and is the live content of the
   chapter.

3. After deletion, **add a single new closing section** (replacing
   the deleted "Use in the project") that honestly describes the
   downstream-consumption chain in the live state:

   ```latex
   \section{Use in the project}
   \label{sec:mv_use_in_project}

   The Mayer-Vietoris infrastructure of this chapter feeds the
   finiteness chain in Chapter~\ref{chap:Cohomology_StructureSheafModuleK}
   as follows. The Čech-vs-derived comparison isomorphism — formalised
   as the carrier class \texttt{HasCechToHModuleIso}
   (\S\ref{sec:cech_acyclicity}, subsection "Comparison-iso typeclass
   carrier") — together with the affine Čech-acyclic cover carrier
   \texttt{HasAffineCechAcyclicCover}
   (\S\ref{sec:cech_acyclicity}, subsection "Affine Čech-acyclic
   cover carrier") together imply
   \texttt{IsAffineHModuleVanishing}, which combined with the
   $H^0$ finiteness ladder of
   Chapter~\ref{chap:Cohomology_StructureSheafModuleK} delivers
   $\Module.\Finite\,k\,H^1(C, \mathcal O_C)$ — the genus carrier.

   \paragraph{Producer status.} The two carrier classes
   \texttt{HasCechToHModuleIso} and \texttt{HasAffineCechAcyclicCover}
   are honestly documented in the carrier subsections above as
   currently unproduced: the project's autonomous-loop scope does
   not include a producer instance for either. Their downstream
   consequences are therefore in place as conditional theorems; a
   producer landing would unlock them. This is the status the
   project ships with: the genus carrier theorem is delivered as a
   conditional under the two carrier hypotheses, parallel to how the
   $\Jac(C)$ side ships conditional under
   \texttt{nonempty\_jacobianWitness}.
   \end{section}  % (closes the new \section, NOT a new env)
   ```

   (Do not literally include "\\end{section}" — that's a
   pseudocode marker for "end the section here". Use blueprint LaTeX
   conventions: sections close implicitly at the next `\section` or
   end of chapter.)

## Out of scope

- **Do not edit** any other chapter, `content.tex`, or any `.lean`
  file. Your write-domain is exactly the one `.tex` file.
- **Do not** try to write or rewrite the live first-half content
  (L1–L940). That content is in mutual agreement with the live Lean
  code per `blueprint-reviewer-iter119`.
- **Do not** add a producer for `HasCechToHModuleIso` or
  `HasAffineCechAcyclicCover` — these are honest
  unproduced-scaffolding carriers and the chapter should not pretend
  otherwise.
- **Do not** mention `BasicOpenCech.lean`, `basicOpenCover`,
  `instIsMonoidal_W`, `cotangentExactSeq_structure.h_exact`,
  `serre_duality_genus`, `PicardFunctor.representable`,
  `SheafOfModules.pullback_tensorObj`, or
  `SheafOfModules.pullback_oneIso` anywhere in the rewritten section.
  These all point at deleted code; their mention is what makes the
  current chapter `complete: partial`.

## References

- `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (the file you edit)
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` and
  `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean` (read these
  ONLY to spot-check that nothing in the first half (L1–L940) is
  also stale — if you find a stale reference there, flag it in the
  report under "Notes for Plan Agent" but do not edit).
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (for the
  genus carrier `IsAffineHModuleVanishing` and finite-rank ladder
  cross-reference in the new "Use in the project" section).
- The directory `AlgebraicJacobian/Cohomology/` (`ls` it, confirm
  `BasicOpenCech.lean` is absent).

## Expected outcome

After your dispatch:
- The chapter is reduced to L1–L915 + a small new "Use in the
  project" section reflecting the live carrier-and-conditional-theorem
  shape.
- Net deletion ~265 lines.
- No `\lean{...}` hint points at a deleted declaration.
- The chapter no longer enumerates the seven-named-deferral surface
  (six items now point at deleted files; only `nonempty_jacobianWitness`
  survives, and it is documented on the `Jacobian.tex` side).
- `complete: true` (no orphan prose), `correct: true` (no false
  claims of formalization).
