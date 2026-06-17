# Blueprint Writer Report

## Slug
mayervietoris-iter119

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Changes Made

- **Deleted** lines 941–1180 of the previous chapter (240 lines of orphan
  content describing deleted Lean code):
  - `\section{Basic-open cover infrastructure}` (former L941) and every
    block under it: the basic-open cover definition, supremum-equality
    theorem, affine-membership theorem, existence producer from
    basic-open evidence (`hasAffineCechAcyclicCover_of_basicOpen` and
    its curve specialisation), `\subsection{Intersection helpers}` with
    its pairwise and $n$-ary intersection theorems and localization
    theorem — **all eight `\lean{AlgebraicGeometry.Scheme.basicOpenCover...}`
    hints pointed at declarations in the deleted file
    `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`**.
  - `\section{Čech acyclicity for the structure sheaf on affine
    basic-open covers}` (former L1089) and its `\section`-internal
    blocks: `splitEpi_pi_lift_of_injective`, the cochain-exactness
    theorem, the substantive theorem
    `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` with its
    four-step proof sketch — all `\lean{...}` hints pointed at the
    deleted file.
  - `\begin{remark}[Finite-subspanning reduction]` (former L1158) and
    `\begin{remark}[Lean implementation]` (former L1163) — orphan
    commentary on the deleted proof.
  - `\begin{remark}[Implementation status (iter-108 escape-valve)]`
    (former L1167) — the seven-named-deferral enumeration, six of whose
    targets (`instIsMonoidal_W`, `cotangentExactSeq_structure.h_exact`,
    `serre_duality_genus`, `PicardFunctor.representable`,
    `SheafOfModules.pullback_tensorObj`,
    `SheafOfModules.pullback_oneIso`) reference deleted Lean files
    (`Modules/Monoidal.lean`, `Picard/LineBundle.lean`,
    `Picard/Functor.lean`, post-iter-117 trimmed `Differentials.lean`).
  - `\subsection{Use in the project}` (former L1174) and the
    `\paragraph{Status (iter-108 / Archon canonical iter-108).}`
    paragraph — both referenced `BasicOpenCech.lean` and its labelled
    sorries (lines 1120, 1212, 1536, 1564, 1754, 1846 — all gone with
    the file).

- **Added** a single closing `\section{Use in the project}` with label
  `sec:mv_use_in_project` (chapter L942–L947). The new section:
  - Names only live carrier classes: `\HasCechToHModuleIso`,
    `\HasAffineCechAcyclicCover`, `\IsAffineHModuleVanishing`.
  - Cross-references existing subsections by `Section~\ref{sec:cech_acyclicity}`
    plus quoted-subsection-title disambiguation (matching the live
    `\subsection{Comparison-iso typeclass carrier}` at L805 and
    `\subsection{Affine Čech-acyclic cover carrier}` at L915).
  - Cross-references `Chapter~\ref{chap:Cohomology_StructureSheafModuleK}`
    for the $H^0$ finiteness ladder (live label, verified).
  - Adds a `\paragraph{Producer status.}` that honestly documents the
    two carriers as currently unproduced — no fabricated formalization
    claim, and parallels the existing `\Jac(C)`-side
    `nonempty_jacobianWitness` conditional as the directive specified.

- **Preserved unchanged** L1–L940 (the entire first half of the chapter
  covering the Mayer–Vietoris LES, two-affine covers, whole-space
  cohomology, finite-rank consequences, comparison-iso scaffolding via
  `HasCechToHModuleIso`, and the affine Čech-acyclic cover carrier
  `HasAffineCechAcyclicCover`).

Net effect: chapter shrunk from 1180 lines to 947 lines (−233 lines).
Begin/end environment counts balanced (110 of each). All 56 unique
`\lean{...}` hints now point at Lean declarations that exist in the
project (spot-checked against `MayerVietorisCore.lean`,
`MayerVietorisCover.lean`, and `StructureSheafModuleK.lean`).

## Cross-references introduced

- `\ref{chap:Cohomology_StructureSheafModuleK}` (twice, in the new
  "Use in the project" section) — verified: this label is defined at
  `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex:2`.
- `\ref{sec:cech_acyclicity}` (twice) — verified: defined at
  `Cohomology_MayerVietoris.tex:767` (the preserved
  `\section{\v{C}ech acyclicity and vanishing on affines}`).
- New label `\label{sec:mv_use_in_project}` — usable as a back-pointer
  from `StructureSheafModuleK.tex` if a future writer wants to
  cross-link the genus-carrier conditional.

No `\uses{...}` clauses were added (the new section is prose, not a
declaration block, so the dependency graph is unaffected).

## Macros needed (if any)

None new. The new section uses only macros already in use elsewhere
in this chapter (`\HasCechToHModuleIso`, `\HasAffineCechAcyclicCover`,
`\IsAffineHModuleVanishing`, `\Jac`, `\Module`, `\Finite`). None of the
deferred references (`\texttt{nonempty\_jacobianWitness}`) require
new macros.

Side observation (not blocking, not my domain to fix): the carrier
macros `\HasCechToHModuleIso`, `\HasAffineCechAcyclicCover`,
`\IsAffineHModuleVanishing` do not appear in
`blueprint/src/macros/common.tex` despite being used inside math mode
in this chapter (verified by `grep -n newcommand` on
`common.tex`). This is a pre-existing condition (these uses are at
chapter L814, L884, etc., in the preserved first half) and not
introduced by my edit. Flagging as informational.

## Reference-retriever dispatches (if any)

None. This was a pure deletion-and-replace task; no new mathematical
content was drafted, so no source material needed retrieval.

## Notes for Plan Agent

- **Mathematical first half is sound.** I spot-checked every unique
  `\lean{...}` hint surviving in L1–L940 against the live Lean files
  in `AlgebraicJacobian/Cohomology/`. Every hint resolves:
  `HModule'_cohomologyPresheafFunctor`, `HModule'_cohomologyPresheaf`,
  `HModule'_sequence`, `HModule'_sequence_exact`, `AffineCoverMVSquare`,
  `toMayerVietorisSquare`, `module_finite_HModule_of_HModule'_X₄`,
  `finrank_HModule_eq_HModule'_X₄`, `HasCechToHModuleIso`,
  `HasAffineCechAcyclicCover`,
  `instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover`,
  `cechToHModuleIso`, `subsingleton_HModule'_of_hasCechToHModuleIso`,
  `subsingleton_HModule_of_isCechAcyclicCover_top`, etc. — all match
  declarations in `MayerVietorisCore.lean`, `MayerVietorisCover.lean`,
  or `StructureSheafModuleK.lean`.

- **Trim coupling with the iter-119 deletion sweep.** The chapter
  no longer enumerates the seven-named-deferral surface. Of those
  seven, only `nonempty_jacobianWitness` (`Jacobian.lean:179`) is
  still live in the project; its prose home is on the
  `Jacobian.tex` side, so no rehoming is needed here. The other six
  evaporated together with the files that contained them.

- **`complete: true`, `correct: true` from a content standpoint.**
  Every claim now made by the chapter maps to live Lean code (with
  the two `Has*` carriers honestly marked as unproduced). The
  `\leanok` annotations on declaration blocks in the preserved first
  half are not in my write-domain to manage (they're handled by
  `sync_leanok`); my changes only deleted blocks, never touched
  surviving annotations.

- **Side-channel observation about `common.tex`:** see the "Macros
  needed" section above for the pre-existing `\HasCechToHModuleIso`
  / `\HasAffineCechAcyclicCover` / `\IsAffineHModuleVanishing`
  macros-not-defined situation. Out of my write-domain; flagging
  for awareness only.

## Strategy-modifying findings

None. The directive's framing — that the project ships the genus
carrier as a conditional under `HasCechToHModuleIso` +
`HasAffineCechAcyclicCover`, parallel to the `Jac(C)` side shipping
conditional under `nonempty_jacobianWitness` — is the live state and
is now honestly documented. No strategy-level surprise emerged from
writing the new "Use in the project" section.
