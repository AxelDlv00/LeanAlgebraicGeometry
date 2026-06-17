# Refactor Directive

## Slug
fence-fix

## Problem
`AlgebraicJacobian/Cohomology/AcyclicResolution.lean` contains a `/-! ... -/` strategy
documentation comment whose body includes a backtick-fenced "suggested output type" code
block (around lines 281–287):

```
Output type (suggested):
```
def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜)
    (hses : ses.ShortExact) (I_A : InjectiveResolution ses.X₁)
    (I_C : InjectiveResolution ses.X₃) :
    InjectiveResolution ses.X₂ × ShortComplex (CochainComplex 𝒜 ℕ)
```
or equivalently expose the SES directly as a field.
```

The `sync_leanok` declaration matcher (and `lean_file_outline` / `lean_local_search`) read
that fenced `def InjectiveResolution.ofShortExact ...` as a REAL, sorry-free declaration,
even though it is inert comment text and `lean_verify` reports the constant does not exist.
This produced a FALSE `\leanok` on the blueprint lemma `lem:injective_resolution_of_ses`
(whose `\lean{}` names `CategoryTheory.InjectiveResolution.ofShortExact`) — DAG poisoning:
the single hardest, still-unbuilt piece of phase P4 is being treated as done.

## Mathematical Justification
None needed — this is a pure documentation/formatting fix inside a comment. The declaration
`InjectiveResolution.ofShortExact` genuinely does NOT exist yet (it is the horseshoe object,
still to be built). The suggested-signature text is useful guidance for the future prover and
should be PRESERVED in meaning; it must merely be reformatted so that no line inside the
comment parses as a Lean declaration of that name.

## Changes Requested
- File: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
  - Old: the backtick code-fence (` ``` `) wrapping the `def InjectiveResolution.ofShortExact
    ... : InjectiveResolution ses.X₂ × ShortComplex (CochainComplex 𝒜 ℕ)` signature inside the
    `/-! ... -/` strategy comment (around L281–287).
  - New: remove the ` ``` ` fences and reformat the signature as plain prose / `-- `-prefixed
    text so that NO line begins with `def InjectiveResolution.ofShortExact` (or any
    `def`/`theorem`/`lemma`/`abbrev`/`instance` + that name). Preserve the informational
    content (the suggested argument list and result type) — e.g. rewrite the opening as
    `-- Suggested output type (NOT yet defined): a function ofShortExact taking ses : ShortComplex 𝒜,`
    `-- hses : ses.ShortExact, I_A : InjectiveResolution ses.X₁, I_C : InjectiveResolution ses.X₃,`
    `-- and returning InjectiveResolution ses.X₂ together with a ShortComplex (CochainComplex 𝒜 ℕ).`
    The exact phrasing is yours; the only hard requirement is that the matcher no longer sees a
    declaration. Scan the WHOLE `/-! ... -/` strategy comment (lines ~197–347) for any OTHER
    backtick-fenced lines beginning with a declaration keyword and reformat those the same way.

## Affected Files
None downstream — the change is confined to a comment. No signatures, no proofs change. The
file must still compile (it already does; verify with `lean_diagnostic_messages`).

## Expected Outcome
- `AcyclicResolution.lean` compiles unchanged in behaviour; sorry count still 0.
- No line inside the `/-! ... -/` strategy comment parses as a `def`/`theorem`/etc. named
  `InjectiveResolution.ofShortExact` (or any other phantom declaration).
- After this lands, the next `sync_leanok` run will strip the false `\leanok` markers from
  `lem:injective_resolution_of_ses` automatically — do NOT edit the blueprint or any `\leanok`.
