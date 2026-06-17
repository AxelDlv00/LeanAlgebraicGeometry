# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
045

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (for every `\lean{...}` block in the chapter that maps to this file)

### `\lean{AlgebraicGeometry.tile_image_opens_identities}` (chapter: `lem:tile_image_opens_identities`)
- **Lean target exists**: yes (line 774)
- **Signature matches**: yes — `(g f : R) : ι ''ᵁ (iso.inv ''ᵁ ⊤) = specBasicOpen g ∧ ι ''ᵁ (iso.inv ''ᵁ D(f̄)) = specBasicOpen (g * f)`; matches the two image-opens equalities in the blueprint
- **Proof follows sketch**: yes — topology/prime-spectrum argument matching the blueprint's set-theoretic proof
- **notes**: clean, `\leanok` on both statement and proof is correct

### `\lean{AlgebraicGeometry.modulesSpecToSheaf_smul_eq}` (chapter: `lem:modulesSpecToSheaf_smul_eq`)
- **Lean target exists**: yes (line 730)
- **Signature matches**: yes
- **Proof follows sketch**: yes — body is `:= rfl`, matching the blueprint's "definitional unfolding" claim
- **notes**: clean

### `\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq}` (chapter: `lem:modulesRestrictBasicOpen_smul_eq`)
- **Lean target exists**: yes (line 740), V=⊤ form only
- **Signature matches**: yes — covers `V = ⊤` (the `c : Γ(⊤, ...)` and `m : (tile).val.obj (op ⊤)` form)
- **Proof follows sketch**: yes — `:= rfl`, matching the blueprint's "definitional unfolding" claim
- **notes**: clean for V=⊤. See unreferenced-declarations section for the new V-general companion.

### `\lean{AlgebraicGeometry.appTop_appIso_inv_eq_res}` (chapter: `lem:appTop_appIso_inv_eq_res`)
- **Lean target exists**: yes (line 815), named `theorem`
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.key_morph}` (chapter: `lem:key_morph`)
- **Lean target exists**: yes (line 829)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.tile_appIso_comp}` (chapter: `lem:tile_appIso_comp`)
- **Lean target exists**: yes (line 845)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.tile_section_ring_identity}` (chapter: `lem:tile_section_ring_identity`)
- **Lean target exists**: yes (line 861)
- **Signature matches**: yes — morphism-level ring identity for V=⊤ (the `ι ''ᵁ ⊤` image open)
- **Proof follows sketch**: yes — route (A): `key_morph` + `tile_appIso_comp`
- **notes**: clean. The general-V companion `tile_section_ring_identity'` (line 934) is new this iter and has no blueprint block — see Major findings.

### `\lean{AlgebraicGeometry.tile_scalar_compat}` (chapter: `lem:tile_scalar_compat`)
- **Lean target exists**: yes (line 890), with `set_option maxHeartbeats 1000000`
- **Signature matches**: yes — scalar reconciliation at V=⊤ only (`c : Γ(⊤,...)`)
- **Proof follows sketch**: yes — two rfl smul bridges + `tile_section_ring_identity` elementwise
- **notes**: clean. The `set_option maxHeartbeats 1000000` annotation signals the defeq check is heavy; this is not a red flag. The general-V companion `tile_scalar_compat'` (line 986) is new this iter and has no blueprint block — see Major and must-fix findings.

### `\lean{AlgebraicGeometry.tile_section_localization}` (chapter: `lem:tile_section_localization`) — **CRITICAL RED FLAG**
- **Lean target exists**: **NO**. The declaration is entirely absent. Lines 1003–1108 contain only a large block comment explaining the declaration is BLOCKED on three Lean-engineering walls (W1–W3), with a sketch of what the proof would look like.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The blueprint carries `\lean{AlgebraicGeometry.tile_section_localization}` (line 4730) AND `\leanok` on BOTH the statement block (line 4727) and the proof block (line 4749). Both `\leanok` markers are **stale**: `\leanok` on the statement block means "at least a sorry present" and on the proof block means "proof closed, no sorry" — but the declaration does not exist in the Lean file at all. → **must-fix-this-iter** (see Red flags section).

---

## Red flags

### Placeholder / suspect bodies

- **`tile_section_localization` — declaration absent**: the Lean file has a `/-` comment block (lines 1003–1108) describing the declaration as BLOCKED. Three Lean-engineering walls are named:
  - **W1**: `letI`/`haveI` for any `Spec`-dependent `Module R` instance hoists into a noncomputable auxiliary def, triggering "failed to compile definition, consider marking it as 'noncomputable' because it depends on 'Spec'" ("noncomputable lemma" is rejected as theorem subsumes noncomputable).
  - **W2**: `IsScalarTower R R_g (tile-carrier)` fails to synthesize: "failed to synthesize SMul ↑R (tile-carrier)" — the tile carrier carries only `Module R_g`, no `Module R`/`SMul R` is found by TC.
  - **W3**: Entire declaration times out at `whnf`/`isDefEq` even at `maxHeartbeats 4000000`.
  
  These are pure Lean-engineering walls; all mathematical ingredients are reported axiom-clean by the prover. The comment block preserves a complete mathematical sketch of the proof.

### `\leanok` markers on a non-existent declaration

- Blueprint line 4727: `\begin{lemma}\leanok` — statement `\leanok` on `lem:tile_section_localization` is **stale** (declaration absent).
- Blueprint line 4749: `\leanok` in proof block — **stale** (no proof to mark clean). These markers were apparently not cleared by `sync_leanok` (possibly because the comment block at lines 1003–1108 was not recognized as a non-declaration). The stale `\leanok` markers make the blueprint dependency graph incorrectly report this leaf as proved, potentially unblocking downstream gates that should be blocked.

### No `sorry` or fake bodies on any other declaration
All 30 other named Lean declarations in this file have real proofs or justified `:= rfl` bodies. No `:= sorry`, `:= True`, or suspect `Classical.choice` patterns found.

---

## Unreferenced declarations (informational)

The following 5 declarations added this iter have no `\lean{...}` blueprint block:

| Declaration | Lines | Nature | Blueprint coverage |
|---|---|---|---|
| `modulesRestrictBasicOpen_smul_eq'` | 756–764 | Non-private lemma; `:= rfl`; general-V companion of blueprinted `modulesRestrictBasicOpen_smul_eq` | Step 4 of `lem:tile_section_localization` mentions the need implicitly; no `\lean{}` block |
| `appIso_inv_res` | 913–919 | **Private** lemma; wrapper for `Scheme.Hom.appIso_inv_naturality` with explicit `homOfLE` | private helper — acceptable without blueprint block |
| `appIso_inv_res_assoc` | 922–927 | **Private** lemma; `Category.assoc`-folded form of `appIso_inv_res` | private helper — acceptable |
| `tile_section_ring_identity'` | 934–973 | **Non-private theorem**; general-V form of blueprinted `tile_section_ring_identity`; 40-line proof | Step 4 of `lem:tile_section_localization` describes the mathematical content ("re-running ... at the composed basic open gf, equivalently, generalising ... from V=⊤ to an arbitrary basic open V"); no `\lean{}` block |
| `tile_scalar_compat'` | 986–1001 | **Non-private lemma**; general-V companion of blueprinted `tile_scalar_compat`; `set_option maxHeartbeats 1000000` | Step 4 of `lem:tile_section_localization` describes it as "additionally required" (future tense); now formalized; no `\lean{}` block |

The two private helpers (`appIso_inv_res`, `appIso_inv_res_assoc`) are genuinely helper-only and do not need blueprint blocks.

The three non-private declarations (`modulesRestrictBasicOpen_smul_eq'`, `tile_section_ring_identity'`, `tile_scalar_compat'`) are substantive contributions whose mathematical content is described (partially) in the Step 4 prose of `lem:tile_section_localization` — they should each receive a dedicated `\lean{}` block.

---

## Blueprint adequacy for this file

**Coverage**: 22/25 named non-private Lean declarations have a corresponding `\lean{...}` block. The 3 unreferenced non-private declarations (`modulesRestrictBasicOpen_smul_eq'`, `tile_section_ring_identity'`, `tile_scalar_compat'`) are substantive; the 2 private helpers are acceptably uncovered.

**Proof-sketch depth**: **under-specified** for `lem:tile_section_localization` Step 4.

The Step-4 sketch (blueprint lines 4788–4800) says the V=D(f̄) scalar compat is obtained by "mechanical reuse of the same route-(A) ΓSpec naturality machinery one localisation deeper" and calls it "the same ring-naturality content, not new mathematics." In practice this required:
- A new named theorem `tile_section_ring_identity'` (40 lines, general-V form of `tile_section_ring_identity`), built from two new private glue lemmas `appIso_inv_res` and `appIso_inv_res_assoc`.
- A new named lemma `tile_scalar_compat'` (17 proof lines + `set_option maxHeartbeats 1000000`), the general-V companion of `tile_scalar_compat`.
- A new named lemma `modulesRestrictBasicOpen_smul_eq'` (general-V companion of `modulesRestrictBasicOpen_smul_eq`).

The Step-4 sketch does NOT name these declarations, does NOT warn about the three Lean-engineering walls W1–W3 (noncomputable-aux hoisting; `SMul`-not-found for `IsScalarTower`; `whnf`/`isDefEq` timeout), and does not provide guidance on the term-mode inline-`@` threading that the in-file comment identifies as the resolution path for W1/W2. A follow-up prover guided only by the blueprint sketch would hit the same walls without prior warning.

**Hint precision**: **loose** for the assembly step. The `\uses` list of `lem:tile_section_localization` cites `lem:tile_scalar_compat` but not `tile_scalar_compat'`, `tile_section_ring_identity'`, or `modulesRestrictBasicOpen_smul_eq'` — the three new ingredients that iter-045 established.

**Generality**: **too narrow** for `lem:tile_scalar_compat`. The block covers V=⊤ only; the V=D(f̄) (and general-V) case is now formalized as `tile_scalar_compat'` but the block does not reference it.

**Stale prose**: Blueprint line 4791 reads: "As formalized, Lemma~\ref{lem:tile_scalar_compat} covers only V = ⊤; Step 4 therefore additionally requires a V = D(f̄) analogue of the scalar compatibility." After iter-045, `tile_scalar_compat'` provides exactly this analogue — the text is **stale** (it describes an open task that is now closed).

**Recommended chapter-side actions**:
1. **(must-fix-this-iter)** Remove the stale `\lean{AlgebraicGeometry.tile_section_localization}` pin from `lem:tile_section_localization`, or guard it with a `% NOTE: declaration BLOCKED on W1–W3 — see in-file comment` annotation, and remove the stale `\leanok` markers from the statement and proof blocks (or flag for `sync_leanok` to re-run).
2. **(major)** Add a dedicated `\lean{}` block for `tile_scalar_compat'` — the general-V companion of `lem:tile_scalar_compat`. The block statement should describe the `V`-parameterized form; the proof sketch should cite `modulesRestrictBasicOpen_smul_eq'` and `tile_section_ring_identity'`.
3. **(major)** Add a dedicated `\lean{}` block for `tile_section_ring_identity'` — the general-V form of `lem:tile_section_ring_identity`, citing the two private helpers `appIso_inv_res`/`appIso_inv_res_assoc`.
4. **(major)** Add a dedicated `\lean{}` block for `modulesRestrictBasicOpen_smul_eq'` — the general-V companion of `lem:modulesRestrictBasicOpen_smul_eq`.
5. **(major)** Update `lem:tile_scalar_compat` (line 4591) to note the V=D(f̄) companion `tile_scalar_compat'` is now formalized.
6. **(major)** Update `lem:tile_section_localization` Step-4 text (lines 4791–4800) to: (a) reference `tile_scalar_compat'` instead of saying "additionally required"; (b) add a `\uses` entry for `tile_scalar_compat'`; (c) add a `% NOTE:` documenting W1–W3 walls and the term-mode inline-`@` threading path so a follow-up prover has concrete guidance.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{AlgebraicGeometry.tile_section_localization}` pin on non-existent declaration; stale `\leanok` on both statement and proof blocks of `lem:tile_section_localization` | **must-fix-this-iter** |
| `tile_scalar_compat'` formalized this iter but no blueprint block; Step-4 text at line 4791 treats it as an open task | **major** |
| `tile_section_ring_identity'` formalized this iter (40-line theorem) but no blueprint block | **major** |
| `modulesRestrictBasicOpen_smul_eq'` formalized this iter but no blueprint block | **major** |
| Step-4 of `lem:tile_section_localization` under-specifies W1–W3 engineering walls; says "mechanical reuse" when 150+ LOC of new lemmas were needed | **major** |
| `lem:tile_scalar_compat` block has no mention of general-V companion `tile_scalar_compat'` | **major** |
| `appIso_inv_res` / `appIso_inv_res_assoc` private helpers without blueprint blocks | **minor** (private helpers — acceptable) |

**Overall verdict**: The 5 new Lean declarations are mathematically faithful and not placeholder/fake; the must-fix-this-iter issue is the `\lean{}` pin and stale `\leanok` markers on `lem:tile_section_localization` pointing at a non-existent declaration — all mathematical ingredients are axiom-clean but the assembly is blocked on W1–W3 instance-plumbing walls that the blueprint's Step-4 sketch does not adequately document.
