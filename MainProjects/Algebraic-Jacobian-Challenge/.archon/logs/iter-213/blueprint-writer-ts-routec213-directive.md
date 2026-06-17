# Blueprint Writer Directive — Picard_TensorObjSubstrate.tex (associator → route (c))

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (ONLY this chapter).

## Strategy context (the slice that matters)

The line-bundle ⊗-group law (A.1.c.SubT) builds `Pic = Units` of the monoid of ⊗-iso-classes of
locally-trivial `Scheme.Modules`. The load-bearing missing piece is the **associator existence
isomorphism** `(M⊗N)⊗P ≅ M⊗(N⊗P)`, an objectwise `Nonempty (… ≅ …)` consumed by the iso-class
group. The chapter's current proof of `lem:tensorobj_assoc_iso` is **mathematically WRONG** at
the "Flatness is free" step and must be rewritten. This was confirmed independently by the
iter-212 prover and the lean-vs-blueprint-checker, and the corrective route was vetted this iter
by the mathlib-analogist (`analogies/ts-monoidal213.md`, slug ts-monoidal213 — READ IT FIRST; it
contains the full route-(c) proof sketch and Decision blocks).

**Why the current proof is wrong.** Steps 1 and 3 invoke `lem:flat_whisker_localizer` (Lean
`W_whiskerLeft_of_flat` / `W_whiskerRight_of_flat`), whose flatness hypothesis is **sectionwise
over every open**, `[∀ U, Module.Flat (𝒪_X(U)) (P.val(U))]`. That is FALSE for non-affine opens:
the site of `Scheme.Modules X` is `TopCat.Sheaf` over ALL of `Opens X`; over a non-affine open
the global-sections functor is not exact and does not preserve flatness, and ⊗-invertibility is
an affine-local property. The "invertible ⇒ projective ⇒ flat" step conflates global
sheaf-invertibility with a global sectionwise condition. **This step is a permanent dead end —
do NOT preserve any version of it.**

Mathlib supplies NEITHER a monoidal `SheafOfModules` NOR a monoidal sheafification (both gated
on the verified-absent `MonoidalClosed (PresheafOfModules R₀)`), and the `tensorObj_restrict_iso`
route was abandoned (strong-monoidal pushforward absent). The ONE viable route is **route (c)**.

## Required edits

### 1. Rewrite `lem:tensorobj_assoc_iso` (statement + proof, chapter ~lines 613–754) to route (c)

**Statement re-scope.** Change the hypotheses from `⊗`-invertible (`def:scheme_modules_isinvertible`)
to **locally trivial** (`LineBundle.IsLocallyTrivial M`, `…N`, `…P`). The consumers
`tensorObjOnProduct`, `exists_tensorObj_inverse`, `tensorObj_isLocallyTrivial` already use
`IsLocallyTrivial`. Update the lemma's `\uses{}` and the proof's `\uses{}`: DROP
`lem:flat_whisker_localizer` and `def:scheme_modules_isinvertible`; ADD the local-triviality
definition label and the new bridge label `lem:isiso_sheafification_map_of_W` (see edit 2b).
Keep the remark that this is an objectwise existence-of-iso (no naturality / no pentagon),
exactly the datum the group law consumes.

**Proof.** Keep the overall shape (3-step composite: absorb inner sheafification on the left,
transport the presheaf associator `a.mapIso α`, restore inner sheafification on the right). The
ONLY changes are in the two absorption steps (1 and 3):

- DELETE the "Flatness is free" paragraph entirely (current lines ~664–669) AND the obsolete
  `% NOTE:` block that follows it (lines ~670–688). DELETE the two `\cref{lem:flat_whisker_localizer}`
  invocations inside steps 1 and 3.
- Replace each absorption step with the route-(c) argument: the whiskered sheafification unit
  `η_{M♭⊗N♭} ▷ P♭` (step 1; resp. `M♭ ◁ η_{N♭⊗P♭}` in step 3) lies in the sheafification
  localizer class `J.W`, proved as:
  - **Local surjectivity** is free (right-exactness; Lean `isLocallySurjective_whiskerLeft`).
  - **Local injectivity** is LOCAL-ON-TARGET (the equalizer sieve is checkable on a cover). Pass
    to a cover `{V → U}` on which `P` is trivial, `P|_V ≅ 𝒪_V` (a sectionwise consequence of
    `IsLocallyTrivial P`, available via the project's `restrictIsoUnitOfLE`). The presheaf tensor
    is sectionwise/definitional, `(A ⊗ᵖ P♭).obj V = A.obj V ⊗_{𝒪(V)} P♭(V)`, so over `V` the
    right unitor `ρ` carries `η ▷ P♭|_V` onto `η|_V` itself; and `η = toSheafify` is locally
    injective (Mathlib `isLocallyInjective_toSheafify`). Glue the covers: `η ▷ P♭` is locally
    injective. (Implementation note for the prover, state it in the proof prose: the existing
    `isLocallyInjective_whiskerLeft_of_flat` is the exact sieve-bookkeeping template — its
    `Module.Flat.lTensor_exact` injectivity step is the only thing swapped, for the
    trivialization-on-the-cover step.)
  - Local injectivity + local surjectivity give `η ▷ P♭ ∈ J.W`; then the CLOSED bridge
    `isIso_sheafification_map_of_W` (edit 2b) inverts it under `a = sheafification`.
- Step 2 (`a.mapIso α`) is unchanged.
- **Correct the closing paragraph** (current ~lines 741–753): it currently asserts the proof
  uses "no per-object local trivialisation or gluing cocycle on an affine cover" — route (c)
  DOES use local trivialisation on a cover, so REWRITE that sentence to say the proof works
  entirely at the presheaf/section level on a trivializing cover. KEEP the (still-true) claims
  that it uses no `MonoidalClosed (PresheafOfModules R)` and no open-immersion
  restriction-compatibility iso (`lem:tensorobj_restrict_iso`).

### 2. Add two missing `\lean{}` pins for the closed iter-212 helpers

(a) In the `lem:flat_whisker_localizer` block, the `\lean{}` currently pins only
`PresheafOfModules.W_whiskerLeft_of_flat`. ADD `PresheafOfModules.W_whiskerRight_of_flat` (the
braiding-conjugate, proven sorry-free iter-212) to the same `\lean{}` list. Add one prose line
noting BOTH halves are proven, and that these flat-whiskering lemmas are now valid standalone
results but are **OFF the associator critical path** (the associator uses route (c), not flatness).

(b) Add a NEW small lemma block, label `lem:isiso_sheafification_map_of_W`,
`\lean{PresheafOfModules.isIso_sheafification_map_of_W}`, placed before `lem:tensorobj_assoc_iso`.
Statement: for a locally-bijective presheaf-of-rings map `α : R₀ ⟶ Rsh.obj` and a
presheaf-of-modules morphism `f` with `J.W ((toPresheaf R₀).map f)`, the sheafification functor
`PresheafOfModules.sheafification α` sends `f` to an isomorphism. This is the go/no-go bridge,
closed axiom-clean iter-212. It is a thin wrapper around Mathlib's
`PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` (the underlying
AddCommGrp sheafification IS the localization at `J.W.inverseImage (toPresheaf R₀)`) read at one
morphism — this is project-bespoke wrapping of existing Mathlib API, so NO external `% SOURCE
QUOTE:` is required; cite the Mathlib lemma name in prose. Mark its `\uses{}` as
`def:scheme_modules_tensorobj` is NOT needed; leave `\uses{}` empty or pointing only at the
sheafification substrate if a label exists.

### 3. Forward note on the iso-class group carrier (do NOT rewrite that lemma's body)

In or near `lem:tensorobj_isoclass_commgroup`, add ONE short prose remark: the group law consumes
the locally-trivial-scoped associator `lem:tensorobj_assoc_iso`; if the `IsInvertible` carrier
form is retained, the bridge `IsInvertible ⇒ IsLocallyTrivial` (the standard "an invertible sheaf
is locally free of rank one") is the only added obligation, and it is off the associator critical
path. Do NOT otherwise rewrite `lem:tensorobj_isoclass_commgroup`.

## References
The route-(c) absorption-iso argument is project-bespoke (the specific sheafification-localization
construction) — no new external `% SOURCE QUOTE:` is needed for it. If you choose to cite the
standard "invertible ⇔ locally free rank 1" fact for the forward note in edit 3, you MUST read a
real local source first (Stacks tag 01CR, or Hartshorne II.6) — `references/**` is authorized so a
reference-retriever child may fetch it if absent. Do not cite from memory.

## Out of scope
- Do NOT touch any other chapter.
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed by sync_leanok / review).
- Do NOT rewrite the unitor (`lem:tensorobj_unit_iso`), braiding (`lem:tensorobj_comm_iso`), or
  `restrictScalars` blocks.
- Do NOT delete the `lem:flat_whisker_localizer` block — it is now off-critical-path but valid.
- Do NOT invent a proof of the route-(c) local-injectivity dependency in Lean syntax; write the
  mathematical argument only.

## Source material to read first
- `analogies/ts-monoidal213.md` (the full route-(c) sketch + Decision blocks — authoritative).
- The current chapter's `lem:tensorobj_assoc_iso` block (lines ~613–754) and
  `lem:flat_whisker_localizer` block (the prose around lines ~560–611).
