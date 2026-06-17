# Blueprint Writer Report

## Slug
ocofd-skeleton

## Status
INCOMPLETE — chapter `RiemannRoch_OcOfD.tex` written in full to spec, BUT the
required `content.tex` update was NOT made: the writer descriptor's hard rule
"Do NOT edit `content.tex`" (`blueprint-writer.md` line 178) overrides the
directive's "single line update in `content.tex`" instruction. The plan
agent must insert
`\input{chapters/RiemannRoch_OcOfD}` into `blueprint/src/content.tex`
manually before the chapter is visible to `leanblueprint` (see "Notes for
Plan Agent" below for the recommended placement and the directive/descriptor
conflict).

## Target chapter
blueprint/src/chapters/RiemannRoch_OcOfD.tex (629 lines, created)

## Changes Made

- **Added chapter** `\chapter{The invertible sheaf $\mathcal O_C(D)$ of a
  Weil divisor (RR.2$_\ast$)}` `\label{chap:RiemannRoch_OcOfD}` —
  blueprints the (currently-missing) Lean file
  `AlgebraicJacobian/RiemannRoch/OcOfD.lean` whose iter-183 file-skeleton
  lane will create the four declarations below.

- **Added §1 "Setup and motivation"** (~30 lines as directed plus
  standing-hypothesis block) — pins three load-bearing strategic facts:
  (a) `RR.2`'s χ-identity helper sorries are gated on the body of
  `sheafOf` and have been waiting since iter-181 Lane H;
  (b) `RR.3`'s `lineBundleAtClosedPoint` consumption routes through the
  closed-point specialisation of `sheafOf` via
  `\Cref{lem:sheafOf_singlePoint}`;
  (c) `RR.4`'s function-field/degree pins consume `sheafOf` for general
  D (not only D = [P]).

- **Added §2 "The invertible sheaf $\mathcal O_C(D)$"** — pins the load-bearing
  definition:
  - **definition** `def:sheafOf` `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf}`
    with Hartshorne II §6 verbatim source quotes (Definition of $\mathscr L(D)$,
    Proposition 6.15, Remark 6.17.1) for the subsheaf-of-$\mathscr K$ construction
    and the Weil-Cartier correspondence on an integral noetherian locally
    factorial scheme. Section-wise definition by per-open
    $\bar k$-submodule of $K(C)$, with the equivalence between this
    description and the Cartier $\{(U_i, f_i)\}$ description spelled out.
    Aligned with `analogies/ocofp-sheaf-internalhom.md` route (iii)
    explicitly.

- **Added §3 (a/b/c) "Immediate corollaries"** — three pinned lemmas:
  - **lemma** `lem:sheafOf_zero`
    `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_zero}` —
    statement plus full proof sketch via the "non-negative order $=$
    regular" identification on an integral scheme.
  - **lemma** `lem:sheafOf_singlePoint`
    `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_singlePoint}` —
    statement plus full proof sketch reducing both descriptions to the
    same constraint set on each open and quoting
    `lem:lineBundleAtClosedPoint_globalSections_iff` of `RR.3` (which the
    directive flagged as the closed-point specialisation under
    `analogies/ocofp-sheaf-internalhom.md`).
  - **lemma** `lem:sheafOf_ses_single_add`
    `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_ses_single_add}` —
    statement plus full proof sketch (Hartshorne IV.1.3 inductive step
    verbatim, then Beat 1 (ideal-sheaf SES via Hartshorne II.6.18) and
    Beat 2 (tensor with the line bundle $\mathcal O_C(D + [P])$,
    three identifications: tensor of line bundles, structure-sheaf-as-unit,
    skyscraper-tensor-by-line-bundle).

- **Added §4 "Sheaf-property correctness"** — sketches functoriality,
  $\bar k$-linearity, sheaf property (via two ingredients: subpresheaf of
  the constant sheaf at $K(C)$ + forget-functor bridge from
  `\mathbf{Sh}(C, \mathbf{Mod}_{\bar k})` to
  `\mathbf{Sh}(C, \mathbf{Set})`), and invertibility (two types of
  trivialising opens: disjoint-from-support and one-prime-divisor).
  Names the project's `Scheme.toModuleKPresheaf` template as the recipe
  and `Scheme.RationalMap.order` from `RR.1` as the locality input.

- **Added §5 "Lean signature pins (iter-183 file skeleton)"** — pins the
  four Lean declarations the iter-183 file-skeleton lane will create,
  recording the `RRFormula.lean:168` move-out and the iter-181 Lane H
  helper unblock.

- **Added §6 "Out of scope"** — five items deferred to post-RR-bridge
  follow-up: linear-equivalence isomorphism, generalised
  $\mathcal O_C(D) \otimes \mathcal O_C(D') \cong \mathcal O_C(D + D')$,
  pullback compatibility, general-D Riemann–Roch space identification,
  Serre duality / canonical sheaf.

## Cross-references introduced

- `\uses{def:codim1_cycles}` in `def:sheafOf`, `lem:sheafOf_zero`,
  `lem:sheafOf_singlePoint`, `lem:sheafOf_ses_single_add` — verified in
  `RiemannRoch_WeilDivisor.tex:219` (the `\lean{}` is
  `AlgebraicGeometry.Scheme.WeilDivisor`). Directive used the label
  name `def:scheme_weil_divisor` (not present in the project); the
  semantically correct existing label is `def:codim1_cycles`.

- `\uses{def:prime_divisor}` — verified in
  `RiemannRoch_WeilDivisor.tex:145`.

- `\uses{def:order_at_point}` — verified in
  `RiemannRoch_WeilDivisor.tex:260`.

- `\uses{def:principal_divisor}` — verified in
  `RiemannRoch_WeilDivisor.tex:585`.

- `\uses{def:divisor_closed_point}` — verified in
  `RiemannRoch_WeilDivisor.tex:386`.

- `\uses{def:lineBundleAtClosedPoint}` — verified in
  `RiemannRoch_OCofP.tex:106`.

- `\uses{lem:lineBundleAtClosedPoint_globalSections_iff}` (used in
  prose, not in a `\uses{}` machine field) — verified in
  `RiemannRoch_OCofP.tex:244`.

- The directive's label `def:scheme_function_field` does NOT exist in
  the blueprint (no `\label{def:scheme_function_field}` anywhere in
  `blueprint/src/chapters/*.tex`). I dropped it from the `\uses{}`
  list and referred to the function field in prose only (citing
  Hartshorne's identification of $\mathcal K_C$ with the constant
  sheaf at $K(C)$). This is consistent with the OCofP chapter, which
  also refers to `C.left.functionField` in prose without a `def:` pin.

## References consulted

- `references/summary.md` — index, identified `hartshorne-algebraic-geometry.md`
  as the primary backing reference for II.6 / IV.1.3 material.

- `references/hartshorne-algebraic-geometry.md` — reference card. Confirmed
  page-offset table (doc page $N$ ↔ PDF page $N+17$, body), the
  scanned-image PDF caveat (no text layer), the contents map
  pointing to II §6 (doc p.129 ↔ PDF p.146) and IV §1 (doc p.293 ↔ PDF
  p.310). Used this to locate the exact PDF pages to render below.

- `references/hartshorne-algebraic-geometry.pdf`, **PDF pages 161–162**
  (doc pages 144–145, Hartshorne II §6) — opened and rendered via
  the `Read` tool's PDF page extraction (the harness rendered the
  scanned image pages so I could read them directly).
  Verbatim source quotes used:
  - "Definition. Let $D$ be a Cartier divisor on a scheme $X$,
    represented by $\{(U_i, f_i)\}$ as above. ... We call $\mathscr L(D)$
    the *sheaf associated to $D$*." (definition of $\mathscr L(D)$)
  - "Proposition 6.15. *If $X$ is an integral scheme, the
    homomorphism $\mathrm{CaCl}\, X \to \mathrm{Pic}\, X$ of (6.14) is
    an isomorphism.* Proof. We have only to show that every invertible
    sheaf is isomorphic to a subsheaf of $\mathscr K$, which in this
    case is the constant sheaf $K$, where $K$ is the function field of
    $X$." (the constant-sheaf-at-$K$ identification)
  - "Remark 6.17.1. Clearly this gives a 1-1 correspondence between
    effective Cartier divisors on $X$ and *locally principal* closed
    subschemes $Y$, ... if $X$ is an integral separated noetherian
    locally factorial scheme, so that the Cartier divisors correspond
    to Weil divisors by (6.11), then the effective Cartier divisors
    correspond exactly to the effective Weil divisors." (Cartier ↔
    Weil correspondence)

- `references/hartshorne-algebraic-geometry.pdf`, **PDF page 313** (doc
  page 296, Hartshorne IV.1.3 inductive step) — opened and rendered.
  Verbatim source quote used:
  - "We consider $P$ as a closed subscheme of $X$. Its structure sheaf
    is a skyscraper sheaf $k$ sitting at the point $P$, which we denote
    by $k(P)$, and its ideal sheaf is $\mathscr L(-P)$ by (II, 6.18).
    Therefore we have an exact sequence
    $0 \to \mathscr L(-P) \to \mathscr O_X \to k(P) \to 0$.
    Tensoring with $\mathscr L(D + P)$ we get
    $0 \to \mathscr L(D) \to \mathscr L(D + P) \to k(P) \to 0$.
    (Since $\mathscr L(D + P)$ is locally free of rank 1, tensoring by
    it does not affect the sheaf $k(P)$.)" (the SES additivity)

- `analogies/ocofp-sheaf-internalhom.md` — the iter-182 api-alignment
  consult. Used to confirm route alignment (option (c) subsheaf-of-$K_C$),
  to ensure `lem:sheafOf_singlePoint` lands as a direct unfolding
  rather than a non-trivial isomorphism, and to record the route choice
  explicitly in §1.

- `blueprint/src/chapters/RiemannRoch_OCofP.tex` — model chapter for
  the citation-block formatting (verbatim quote layout, `\textit{Source:}`
  prefix discipline, "no text layer" preamble comment),
  cross-references to `def:lineBundleAtClosedPoint` /
  `lem:lineBundleAtClosedPoint_globalSections_iff`, and the
  iter-181 lean-auditor MAJOR finding context (the closed-point
  specialisation as the immediate downstream consumer).

- `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — for the
  iter-181 Lane H helper sorries (`eulerCharacteristic_sheafOf_zero`,
  `eulerCharacteristic_sheafOf_succ`) and their gating on `sheafOf`'s
  body. Used to write §1's "Why this chapter is gated to RR.2".

- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — for the
  cross-reference labels (`def:codim1_cycles`, `def:prime_divisor`,
  `def:order_at_point`, `def:principal_divisor`,
  `def:divisor_closed_point`) and the standing-hypothesis style.

- `AlgebraicJacobian/RiemannRoch/RRFormula.lean` lines 140–195 — for
  the existing `sheafOf` typed-sorry signature (which the iter-183
  Lean file-skeleton lane will move into `OcOfD.lean`), the gating
  docstring, and the iter-181 Lane H factoring narrative inside the
  Lean file.

- `blueprint/src/content.tex` — read to identify the canonical
  placement position (after `RiemannRoch_OCofP`, since the current
  order is WeilDivisor → RRFormula → OCofP → RationalCurveIso).
  **NOT edited** (descriptor rule wins, see "Notes for Plan Agent").

## Reference-retriever dispatches (if any)

None. The directive permitted a child `reference-retriever` if
`hartshorne-graduate.pdf` was missing, but `hartshorne-algebraic-geometry.pdf`
is already in `references/` (the same Hartshorne GTM 52) and the
required pages are readable via PDF-page-rendering in the `Read` tool.
No external retrieval needed.

## Notes for Plan Agent

### content.tex update — directive/descriptor conflict

The directive explicitly asked for "Insert a single
`\input{chapters/RiemannRoch_OcOfD}` line in `blueprint/src/content.tex`
in the canonical position (after `\input{chapters/RiemannRoch_OCofP}`
and before `\input{chapters/RiemannRoch_RRFormula}`)." The writer
descriptor's "What you MUST NOT do" list (`blueprint-writer.md`
line 178) hard-rules: "Do NOT edit `content.tex` (the top-level
blueprint file that `\input`s the chapters)." I obeyed the descriptor
(per the Priority Rule in `.archon/CLAUDE.md`, local hard rules take
precedence) and did NOT touch `content.tex`.

**Recommended placement** (since the directive's literal
"after OCofP and before RRFormula" is impossible given current order):
insert **immediately after `RiemannRoch_OCofP`**, between line 33 and
line 34. The current order is

```
\input{chapters/RiemannRoch_WeilDivisor}     % line 31
\input{chapters/RiemannRoch_RRFormula}       % line 32
\input{chapters/RiemannRoch_OCofP}           % line 33
\input{chapters/RiemannRoch_RationalCurveIso}% line 34
```

so the directive's literal placement ("after OCofP, before RRFormula")
cannot be satisfied. Inserting after OCofP is the closest semantic
match: OcOfD is the general construction of which OCofP is the closed-point
specialisation, so OCofP → OcOfD reads naturally.

**Recommended one-line edit for the plan agent:**

```
\input{chapters/RiemannRoch_WeilDivisor}
\input{chapters/RiemannRoch_RRFormula}
\input{chapters/RiemannRoch_OCofP}
\input{chapters/RiemannRoch_OcOfD}            % <-- NEW LINE
\input{chapters/RiemannRoch_RationalCurveIso}
```

### Directive label rename (`def:scheme_weil_divisor` → `def:codim1_cycles`)

The directive specified
`\uses{def:scheme_weil_divisor, def:scheme_function_field}` for
`def:sheafOf`. Neither label exists in the blueprint:

- `def:scheme_weil_divisor` is not present anywhere in
  `blueprint/src/chapters/*.tex`. The semantically-correct existing
  label is `def:codim1_cycles` at `RiemannRoch_WeilDivisor.tex:219`
  (its `\lean{}` is `AlgebraicGeometry.Scheme.WeilDivisor`, which is
  exactly the type the directive intended). I substituted
  `def:codim1_cycles` in the `\uses{}`.
- `def:scheme_function_field` is not present anywhere in
  `blueprint/src/chapters/*.tex`. Following the OCofP precedent (which
  also refers to the function field in prose without a `def:` pin), I
  dropped this from the `\uses{}` machine field and referred to the
  function field in prose only.

If the plan agent wants a formal pin for the function field, the
recommended path is to add a new `def:scheme_function_field` block to
`RiemannRoch_WeilDivisor.tex` (the function field is referenced
throughout `RR.1`, especially in `def:order_at_point` and
`def:principal_divisor`) — but this is out of scope for the present
chapter and would be a separate writer dispatch.

### Chapter length

The chapter is 629 lines, longer than the directive's per-section
guidance (~30 + 80 + 60 + 10 = ~180–285 lines). The overage is in §3
"Immediate corollaries" (each lemma has a full proof sketch with cross-
reference packaging) and §4 "Sheaf-property correctness" (the recipe
sketch covers four sub-points). The sibling chapter
`RiemannRoch_OCofP.tex` is 742 lines, so the present chapter is
within the established sibling-chapter scale. No structural concern,
but flagged here for the plan agent's visibility.

### `\Cref{prop:genusZero_curve_iso_P1}` — forward reference

§1 quotes the bridge consumed by
`\Cref{prop:genusZero_curve_iso_P1}` of
`AbelianVarietyRigidity.tex`. I copied this exact reference verbatim
from sibling chapters (`RiemannRoch_OCofP.tex` line 6 of its `% NOTE`
block uses the same one). I did not verify the existence of this
label in `AbelianVarietyRigidity.tex`; if it is stale, all sibling
chapters in `RR.*` carry the same forward reference and will all need
to be updated together.

## Strategy-modifying findings

None. The chapter is fully consistent with the iter-182
`ocofp-sheaf-internalhom` analogist verdict
(route (iii) subsheaf-of-$\mathcal K_C$), with the iter-181 Lane H
factoring of `RR.2` (the two helper sorries that gate on the body of
`sheafOf`), and with the existing `RR.3` closed-point specialisation
in `RiemannRoch_OCofP.tex`. The Hartshorne II.6 / IV.1.3 source
material directly supplies all four pinned declarations
(`def:sheafOf`, `lem:sheafOf_zero`, `lem:sheafOf_singlePoint`,
`lem:sheafOf_ses_single_add`) with verbatim source quotes; no
divergent-route discovery surfaced.
