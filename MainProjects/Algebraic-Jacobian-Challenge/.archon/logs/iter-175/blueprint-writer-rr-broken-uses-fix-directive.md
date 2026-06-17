# Blueprint Writer Directive

## Slug
rr-broken-uses-fix

## Target chapter
blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex

## Strategy context

RR.4 (rational curve `≅ ℙ¹`) is the bridge that finishes the genus-0
arm: a genus-0 curve with a `k̄`-point is isomorphic to `ℙ¹`. The
chapter landed iter-174 plan-phase. The blueprint-doctor flagged
**1 broken cross-reference**: `\uses{cor:nonconstant_function_genus_zero}`
with no matching `\label{cor:nonconstant_function_genus_zero}` anywhere
in the included `.tex` tree. The intended target likely lives in the
still-unfinished `RiemannRoch_OCofP.tex` chapter (the iter-174 RR.3
landing).

## Required content

NARROW SCOPE. Your job is to close the broken `\uses{}` reference:

1. **Locate the broken `\uses{cor:nonconstant_function_genus_zero}` in
   `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`** (probably
   appears twice based on the blueprint-doctor JSON — once in the
   theorem's `\uses{}` annotation, once in a proof's `\uses{}`).

2. **Check whether `cor:nonconstant_function_genus_zero` is meant to live
   in `RiemannRoch_OCofP.tex`** (the RR.3 chapter that pins
   `def:O_C_of_P` / `thm:O_C_of_P_global_sections`). Open
   `RiemannRoch_OCofP.tex` and look for a corollary block introducing
   the "non-constant function on a genus-0 curve" fact (Hartshorne
   IV.1.3.5 setup: `dim_{k̄} H⁰(C, O_C(P)) = 2`, so there is a non-constant
   `f ∈ H⁰(C, O_C(P))`).

3. **Resolution branch A (if target exists or can be added cheaply
   to RR.3)**: Add the `\label{cor:nonconstant_function_genus_zero}` to
   the appropriate corollary block in `RiemannRoch_OCofP.tex` (this
   means dispatching a sibling edit on RR.3's chapter — **YES, this
   directive authorises that exact edit** in your write-domain). Use
   a corollary block of the form:

       \begin{corollary}[Non-constant function on genus-0 curve]
         \label{cor:nonconstant_function_genus_zero}
         \uses{thm:O_C_of_P_global_sections}
         ... brief 2-3 line corollary deriving the existence of a
         non-constant `f ∈ H⁰(C, O_C(P))` from `dim_{k̄} H⁰ = 2` ...
       \end{corollary}

   adjacent to wherever RR.3 finishes the `dim = 2` theorem block.

4. **Resolution branch B (if target is a re-naming / typo)**: If you
   determine the writer meant to reference an *existing* label under a
   different name (e.g., `thm:nonconstant_function_genus_zero` lives
   somewhere with a slightly different tag), correct the `\uses{}` in
   `RationalCurveIso.tex` to that existing label.

5. **Resolution branch C (if neither branch applies)**: Drop the
   `\uses{cor:nonconstant_function_genus_zero}` annotation from the
   `RationalCurveIso.tex` blocks; the chapter prose presumably already
   states the dependency informally, and `\uses{}` is supposed to back
   formal label dependencies. Mark a `% NOTE:` comment briefly
   explaining the deletion if you take this branch.

**Strongly prefer Branch A** — adding the missing `\label` to RR.3 is
the cheapest fix and aligns with the dependency graph the writer
clearly intended.

## Out of scope

- Do NOT rewrite the chapter prose of either file.
- Do NOT add unrelated declarations.
- Do NOT touch `\leanok` or `\mathlibok` markers.
- Do NOT change other chapters.
- Do NOT change the `\lean{...}` pins or `\label{...}` lines elsewhere
  in either file.

## References

- `references/hartshorne.pdf`: Hartshorne IV.1.3.5 + IV.1.4 background
  on the non-constant function from `O_C(P)` global sections.

## Expected outcome

After your edit:
- `RiemannRoch_RationalCurveIso.tex`'s 2 broken `\uses{...}` references
  resolve (either to a new `\label` in `RiemannRoch_OCofP.tex`, or to a
  renamed existing label, or are removed).
- The blueprint-doctor's `broken_refs` count drops from 2 to 0 for this
  pair of chapters.
- No other edits.
